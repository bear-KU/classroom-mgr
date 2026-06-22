class ParsedInput
    attr_reader :command_name, :arguments, :options

    def initialize(command_name:, arguments:, options:)
        @command_name = command_name
        @arguments = arguments
        @options = options
    end
end