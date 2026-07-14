require_relative 'test_helper'
require_relative '../lib/input_parser'
require_relative '../lib/error_handler'

class InputParserTest < Minitest::Test
    def test_parse_read_command_with_one_argument
        parsed_input = InputParser.parse('read ./2026')

        assert_instance_of ParsedInput, parsed_input
        assert_equal 'read', parsed_input.command_name
        assert_equal ['./2026'], parsed_input.arguments
        assert_equal({}, parsed_input.options)
    end

    def test_parse_quoted_argument_as_one_argument
        parsed_input = InputParser.parse('read "./2026 data"')

        assert_instance_of ParsedInput, parsed_input
        assert_equal 'read', parsed_input.command_name
        assert_equal ['./2026 data'], parsed_input.arguments
    end

    def test_parse_double_quoted_hyphen_argument
        parsed_input = InputParser.parse('read "-2026"')

        assert_instance_of ParsedInput, parsed_input
        assert_equal 'read', parsed_input.command_name
        assert_equal ['-2026'], parsed_input.arguments
        assert_equal({}, parsed_input.options)
    end

    def test_parse_single_quoted_hyphen_argument
        parsed_input = InputParser.parse("read '-2026'")

        assert_instance_of ParsedInput, parsed_input
        assert_equal 'read', parsed_input.command_name
        assert_equal ['-2026'], parsed_input.arguments
        assert_equal({}, parsed_input.options)
    end

    def test_parse_double_quoted_double_hyphen_argument
        parsed_input = InputParser.parse('read "--2026"')

        assert_instance_of ParsedInput, parsed_input
        assert_equal 'read', parsed_input.command_name
        assert_equal ['--2026'], parsed_input.arguments
        assert_equal({}, parsed_input.options)
    end

    def test_parse_single_quoted_double_hyphen_argument
        parsed_input = InputParser.parse("read '--2026'")

        assert_instance_of ParsedInput, parsed_input
        assert_equal 'read', parsed_input.command_name
        assert_equal ['--2026'], parsed_input.arguments
        assert_equal({}, parsed_input.options)
    end

    def test_parse_double_quoted_hyphen_argument_with_space
        parsed_input = InputParser.parse('read "-2026 data"')

        assert_instance_of ParsedInput, parsed_input
        assert_equal ['-2026 data'], parsed_input.arguments
    end

    def test_parse_single_quoted_hyphen_argument_with_space
        parsed_input = InputParser.parse("read '-2026 data'")

        assert_instance_of ParsedInput, parsed_input
        assert_equal ['-2026 data'], parsed_input.arguments
    end

    def test_parse_empty_double_quoted_argument
        parsed_input = InputParser.parse('read ""')

        assert_instance_of ParsedInput, parsed_input
        assert_equal [''], parsed_input.arguments
    end

    def test_parse_empty_single_quoted_argument
        parsed_input = InputParser.parse("read ''")

        assert_instance_of ParsedInput, parsed_input
        assert_equal [''], parsed_input.arguments
    end

    def test_parse_read_command_without_argument_returns_error
        assert_equal ErrorHandler::ERROR_UNKNOWN_OPTION, InputParser.parse('read')
    end

    def test_parse_read_command_with_extra_argument_returns_error
        assert_equal ErrorHandler::ERROR_UNKNOWN_OPTION, InputParser.parse('read ./2026 extra')
    end

    def test_parse_quit_command_with_extra_argument_returns_error
        assert_equal ErrorHandler::ERROR_UNKNOWN_OPTION, InputParser.parse('quit extra')
    end

    def test_parse_unclosed_quote_returns_error
        assert_equal ErrorHandler::ERROR_UNKNOWN_OPTION, InputParser.parse('read "unclosed')
    end

    def test_parse_unclosed_single_quote_returns_error
        assert_equal ErrorHandler::ERROR_UNKNOWN_OPTION, InputParser.parse("read '-2026")
    end

    def test_parse_unquoted_hyphen_argument_returns_error
        assert_equal ErrorHandler::ERROR_UNKNOWN_OPTION, InputParser.parse('read -2026')
    end

    def test_parse_unknown_long_option_returns_error
        assert_equal ErrorHandler::ERROR_UNKNOWN_OPTION, InputParser.parse('read --unknown')
    end

    def test_parse_print_options_without_arguments
        parsed_input = InputParser.parse('print -d 0706 -s "情報 科学"')

        assert_instance_of ParsedInput, parsed_input
        assert_equal 'print', parsed_input.command_name
        assert_equal [], parsed_input.arguments
        assert_equal({ date: '0706', subject: '情報 科学' }, parsed_input.options)
    end

    def test_parse_create_without_option
        parsed_input = InputParser.parse('create')

        assert_instance_of ParsedInput, parsed_input
        assert_equal({}, parsed_input.options)
    end

    def test_parse_create_with_short_term_option
        parsed_input = InputParser.parse('create -t 1')

        assert_instance_of ParsedInput, parsed_input
        assert_equal({ term: '1' }, parsed_input.options)
    end

    def test_parse_create_with_long_term_option
        parsed_input = InputParser.parse('create --term 1')

        assert_instance_of ParsedInput, parsed_input
        assert_equal({ term: '1' }, parsed_input.options)
    end

    def test_parse_print_with_short_date_option
        parsed_input = InputParser.parse('print -d 0501')

        assert_instance_of ParsedInput, parsed_input
        assert_equal({ date: '0501' }, parsed_input.options)
    end

    def test_parse_print_with_short_subject_option
        parsed_input = InputParser.parse('print -s 数学')

        assert_instance_of ParsedInput, parsed_input
        assert_equal({ subject: '数学' }, parsed_input.options)
    end

    def test_parse_print_with_different_short_options
        parsed_input = InputParser.parse('print -d 0501 -s 数学')

        assert_instance_of ParsedInput, parsed_input
        assert_equal({ date: '0501', subject: '数学' }, parsed_input.options)
    end

    def test_parse_print_with_different_long_options
        parsed_input = InputParser.parse('print --date 0501 --subject 数学')

        assert_instance_of ParsedInput, parsed_input
        assert_equal({ date: '0501', subject: '数学' }, parsed_input.options)
    end

    def test_parse_print_with_different_mixed_options
        parsed_input = InputParser.parse('print -d 0501 --subject 数学')

        assert_instance_of ParsedInput, parsed_input
        assert_equal({ date: '0501', subject: '数学' }, parsed_input.options)
    end

    def test_parse_duplicate_options_returns_error_without_raising
        duplicate_option_inputs = [
            'create -t 1 -t 2',
            'create --term 1 --term 2',
            'create -t 1 --term 2',
            'create --term 1 -t 2',
            'print -d 0501 -d 0502',
            'print --date 0501 --date 0502',
            'print -d 0501 --date 0502',
            'print -s 数学 -s 英語',
            'print --subject 数学 --subject 英語',
            'print -s 数学 --subject 英語'
        ]

        duplicate_option_inputs.each do |input|
            assert_equal ErrorHandler::ERROR_UNKNOWN_OPTION, InputParser.parse(input), input
        end
    end

    def test_parse_print_option_with_double_quoted_hyphen_value
        parsed_input = InputParser.parse('print -s "-情報処理"')

        assert_instance_of ParsedInput, parsed_input
        assert_equal({ subject: '-情報処理' }, parsed_input.options)
    end

    def test_parse_print_option_with_single_quoted_hyphen_value
        parsed_input = InputParser.parse("print -s '-情報処理'")

        assert_instance_of ParsedInput, parsed_input
        assert_equal({ subject: '-情報処理' }, parsed_input.options)
    end

    def test_parse_create_unknown_option_returns_error
        assert_equal ErrorHandler::ERROR_UNKNOWN_OPTION, InputParser.parse('create -x 1')
    end

    def test_parse_print_single_hyphen_subject_returns_error
        assert_equal ErrorHandler::ERROR_UNKNOWN_OPTION, InputParser.parse('print -subject 数学')
    end
end
