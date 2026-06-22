require "optparse"
require_relative "parsed_input"

class InputParser
    def self.parse(input)
        # (1) inputが文字列であるか確認する
        unless input.is_a?(String)
            # 仮の出力
            raise TypeError, "inputにはStringを指定してください．"
        end

        option_parser = OptionParser.new # (2) OptionParserインスタンスを生成する
        tokens = input.split # (3) 入力文字列を半角スペースなどで分割する
        command_name = tokens.shift # (4) 先頭要素からコマンド名を取得する
        options = {}

        # (5) コマンドに応じてオプションを登録する
        register_options(option_parser, command_name, options)

        # (6) オプションを解析する
        option_parser.parse!(tokens)

        # parse!後にtokensへ残っている要素が引数になる
        arguments = tokens

        # (7) ParsedInputインスタンスを生成して返す
        ParsedInput.new(
            command_name: command_name,
            options: options,
            arguments: arguments
        )
    end

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

    private_class_method :register_options
end