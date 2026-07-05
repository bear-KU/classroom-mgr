require_relative "input_parser"
require_relative "parsed_input"
require_relative "command_factory"
require_relative "error_handler"
require_relative "managed_lecture_room_information_repository"
require_relative "academic_calendar_information_repository"
require_relative "timetable_information_repository"
require_relative "reservation_information_repository"
require_relative "lecture_room_management_information_repository"
require_relative "interactive_menu"
require_relative "excel_data_exporter"

class Application
    # 初期化メソッド
    def initialize
        @lecture_room_management_information_repository = LectureRoomManagementInformationRepository.new
        @academic_calendar_information_repository = AcademicCalendarInformationRepository.new
        @timetable_information_repository = TimetableInformationRepository.new
        @reservation_information_repository = ReservationInformationRepository.new
        @managed_lecture_room_information_repository = ManagedLectureRoomInformationRepository.new
        @interactive_menu = InteractiveMenu.new
        @excel_data_exporter = ExcelDataExporter.new
        @command_factory = CommandFactory.new(
            @lecture_room_management_information_repository,
            @academic_calendar_information_repository,
            @timetable_information_repository,
            @reservation_information_repository,
            @managed_lecture_room_information_repository,
            @interactive_menu,
            @excel_data_exporter
        )
    end

    # システムのメインループを開始
    def start_system_loop
        loop do
            input = wait_input
            parsed_input = InputParser.parse(input)

            if parsed_input.is_a?(Integer)
                ErrorHandler.print_error(parsed_input)
                next
            end 

            # コマンド生成
            command = @command_factory.create(
                parsed_input.command_name, 
                parsed_input.arguments,
                parsed_input.options
            )
            command_result = command.execute # コマンド実行

            # コマンドの実行結果を確認し，失敗している場合はエラー番号を表示
            unless command_result.is_succeed
                ErrorHandler.print_error(command_result.error_number)
            end

            stop_system if command_result.exit_flag # exit_flagが立っていたら終了
        end
    end

    # 標準入力からの入力を待機
    def wait_input
        print "> "

        $stdin.set_encoding(Encoding::UTF_8)
        input = $stdin.gets
        return nil if input.nil?

        input.chomp # 改行コードを削除
    end

    # システムの終了
    def stop_system
        exit
    end
end
