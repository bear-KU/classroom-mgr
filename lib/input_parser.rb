require "optparse"
require_relative "parsed_input"
require_relative "error_handler"

class InputParser
    COMMAND_NAMES = [
        "read",
        "select",
        "create",
        "print",
        "write",
        "quit"
    ].freeze

    def self.parse(input)
        # (1) inputが文字列であるか確認する
        unless input.is_a?(String)
            raise TypeError, "input must be a String"
        end

        option_parser = OptionParser.new # (2) OptionParserインスタンスを生成
        tokens = input.split             # (3) 入力文字列を半角スペースで分割
        command_name = tokens.shift      # (4) 先頭要素からコマンド名を取得
        options = {}

        # (4) コマンド名が有効かどうか確認
        unless COMMAND_NAMES.include?(command_name)
            return ErrorHandler::ERROR_UNKNOWN_COMMAND
        end

        # OptionParserは「-subject」を「-s bject」と解釈
        # 「-」で始まる場合は，長さが3文字以上のトークンをエラーとして扱う
        if tokens.any? { |token| token.start_with?("-") && !token.start_with?("--") && token.length > 2 }
            return ErrorHandler::ERROR_UNKNOWN_OPTION
        end

        # (5) コマンドに応じてオプションを登録
        register_options(option_parser, command_name, options)

        # (6) オプションを解析
        begin
            option_parser.parse!(tokens)
        rescue OptionParser::InvalidOption
            return ErrorHandler::ERROR_UNKNOWN_OPTION
        rescue OptionParser::MissingArgument
            return ErrorHandler::ERROR_UNKNOWN_OPTION
        end

        arguments = tokens

        # (7) ParsedInputインスタンスを生成して返却
        ParsedInput.new(command_name: command_name, options: options, arguments: arguments)
    end

    # オプション引数を登録するメソッド
    def self.register_options(option_parser, command_name, options)
        case command_name
        when "create"
            option_parser.on("-t TERM", "--term TERM") do |term|
            options[:term] = term.to_i
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

    private_class_method :register_options
end
