require_relative '../test_helper'
require_relative '../../lib/read_command'

class ReadCommandTest < Minitest::Test
  def test_returns_file_not_found_when_academic_calendar_is_deleted_before_loading
    original_loader = ExcelDataLoader.method(:load_academic_calendar_xlsx_file)
    ExcelDataLoader.define_singleton_method(:load_academic_calendar_xlsx_file) do |_directory_path|
      raise Errno::ENOENT, 'deleted.xlsx'
    end

    result = ReadCommand.new(
      AcademicCalendarInformationRepository.new,
      TimetableInformationRepository.new,
      ReservationInformationRepository.new,
      'test_data'
    ).execute

    assert_equal false, result.is_succeed
    assert_equal ErrorHandler::ERROR_ACADEMIC_CALENDAR_FILE_NOT_FOUND, result.error_number
  ensure
    ExcelDataLoader.define_singleton_method(:load_academic_calendar_xlsx_file, &original_loader)
  end
end
