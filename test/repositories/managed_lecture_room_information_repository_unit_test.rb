require_relative '../test_helper'
require_relative '../../lib/managed_lecture_room_information_repository'
require_relative '../../lib/managed_lecture_room_information'

class ManagedLectureRoomInformationRepositoryTest < Minitest::Test
    def setup
        @room_a = ManagedLectureRoomInformation.new(room_name: 'Room A')
        @room_b = ManagedLectureRoomInformation.new(room_name: 'Room B')
    end

    def test_initialize_and_find_all
        repository = ManagedLectureRoomInformationRepository.new(
            managed_lecture_room_informations: [@room_a]
        )

        assert_equal [@room_a], repository.find_all
    end

    def test_add_remove_and_replace_all
        repository = ManagedLectureRoomInformationRepository.new
        repository.add(@room_a)
        repository.add(@room_b)
        assert_equal [@room_a, @room_b], repository.find_all

        repository.remove(@room_a)
        assert_equal [@room_b], repository.find_all

        repository.replace_all([@room_a])
        assert_equal [@room_a], repository.find_all
    end

    def test_invalid_initialization_argument
        assert_raises(ArgumentError) do
            ManagedLectureRoomInformationRepository.new(managed_lecture_room_informations: 'not an array')
        end
    end
end
