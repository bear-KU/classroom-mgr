require 'optparse'
require_relative 'parsed_input'
require_relative 'error_handler'

class InputParser
    # 入力を分割した後も，引用符で囲まれていたかを保持するための構造体
    Token = Struct.new(:value, :quoted, keyword_init: true)

    # コマンド名の定義
    COMMAND_NAMES = [
        "read",
        "select",
        "create",
        "print",
        "write",
        "quit"
    ].freeze

    # コマンドごとの引数の個数を定義
    COMMAND_ARGUMENT_COUNTS = {
        "read" => 1,
        "select" => 0,
        "create" => 0,
        "print" => 0,
        "write" => 1,
        "quit" => 0
    }.freeze

    # 引用符付きの「-」始まりの値をOptionParserにオプションと誤認させないための一時文字列
    QUOTED_TOKEN_PREFIX = "__input_parser_quoted_token_".freeze

    def self.parse(input)
        # (1) inputが文字列であるか確認する
        unless input.is_a?(String)
            raise TypeError, "input must be a String"
        end

        option_parser = OptionParser.new # (2) OptionParserインスタンスを生成
        begin
            # (3) クォーテーション情報を保持して分割
            parsed_tokens = split_with_quote_information(input)
        rescue ArgumentError
            # クォーテーションの閉じ忘れなど，入力文字列として解析できない場合
            return ErrorHandler::ERROR_UNKNOWN_OPTION
        end
        command_name = parsed_tokens.shift&.value # (4) 先頭要素からコマンド名を取得
        options = {}

        # (4) コマンド名が有効かどうか確認
        unless COMMAND_NAMES.include?(command_name)
            return ErrorHandler::ERROR_UNKNOWN_COMMAND
        end

        # OptionParserは「-subject」を「-s ubject」と解釈
        # 引用符なしの短縮オプション風トークンだけを，事前に不正オプションとして扱う
        if parsed_tokens.any? { |token| !token.quoted && token.value.start_with?("-") && !token.value.start_with?("--") && token.value.length > 2 }
            return ErrorHandler::ERROR_UNKNOWN_OPTION
        end

        # (5) コマンドに応じてオプションを登録
        register_options(option_parser, command_name, options)

        # 引用符付きの「-」始まりの値だけを一時的に置換
        # 例: read "-2026" の -2026 をOptionParserにオプション扱いしない
        quoted_token_values = {}
        tokens = parsed_tokens.each_with_index.map do |token, index|
            if token.quoted && token.value.start_with?("-")
                placeholder = "#{QUOTED_TOKEN_PREFIX}#{index}__"
                quoted_token_values[placeholder] = token.value
                placeholder
            else
                token.value
            end
        end

        # (6) オプションを解析
        begin
            option_parser.parse!(tokens)
        rescue OptionParser::InvalidOption
            return ErrorHandler::ERROR_UNKNOWN_OPTION
        rescue OptionParser::MissingArgument
            return ErrorHandler::ERROR_UNKNOWN_OPTION
        end

        # OptionParserで解析した後，プレースホルダーを利用者が入力した値に戻す。
        restore_quoted_token_values!(tokens, quoted_token_values)
        restore_quoted_token_values!(options, quoted_token_values)

        # 引数の個数を確認し，不足または超過している場合はエラー番号を返却
        arguments = tokens
        unless arguments.length == COMMAND_ARGUMENT_COUNTS[command_name]
            return ErrorHandler::ERROR_UNKNOWN_COMMAND
        end

        # (7) ParsedInputインスタンスを生成して返却
        ParsedInput.new(command_name: command_name, options: options, arguments: arguments)
    end

    # 空白，ダブルクォート，シングルクォートを考慮して入力文字列を分割
    def self.split_with_quote_information(input)
        tokens = []
        current_token = +""
        current_quote = nil
        token_started = false
        token_quoted = false

        input.each_char do |char|
            if current_quote
                # 引用符内では空白も通常文字として扱い，同じ引用符が来たら引用を終了
                if char == current_quote
                    current_quote = nil
                else
                    current_token << char
                end
            elsif char == '"' || char == "'"
                # 引用符の開始。read "" のような空文字列もトークンとして扱う
                current_quote = char
                token_started = true
                token_quoted = true
            elsif char.match?(/\s/)
                # 引用符の外側の空白はトークン区切りとして扱う
                if token_started
                    tokens << Token.new(value: current_token, quoted: token_quoted)
                    current_token = +""
                    token_started = false
                    token_quoted = false
                end
            else
                current_token << char
                token_started = true
            end
        end

        # 引用符が閉じていない場合は，呼び出し元で入力解析エラーに変換
        raise ArgumentError, "unclosed quote" unless current_quote.nil?

        tokens << Token.new(value: current_token, quoted: token_quoted) if token_started
        tokens
    end

    # OptionParserに渡す前に置き換えた一時文字列を，元の引用符付きトークン値に戻す
    def self.restore_quoted_token_values!(target, quoted_token_values)
        case target
        when Array
            target.map! { |value| quoted_token_values.fetch(value, value) }
        when Hash
            target.each do |key, value|
                target[key] = quoted_token_values.fetch(value, value)
            end
        end
    end

    # オプション引数を登録するメソッド
    def self.register_options(option_parser, command_name, options)
        case command_name
        when "create"
            option_parser.on("-t TERM", "--term TERM") do |term|
            options[:term] = term
            end
        when "print"
            option_parser.on("-d DATE", "--date DATE") do |date|
            options[:date] = date
            end

            option_parser.on("-s SUBJECT", "--subject SUBJECT") do |subject|
            options[:subject] = subject
            end
        end
    end

    private_constant :Token
    private_class_method :split_with_quote_information
    private_class_method :restore_quoted_token_values!
    private_class_method :register_options
end
