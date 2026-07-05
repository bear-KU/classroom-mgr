class CreateCommand
  def initialize(
    lecture_room_management_information_repository,
    academic_calendar_information_repository,
    timetable_information_repository,
    reservation_information_repository,
    managed_lecture_room_information_repository,
    interactive_menu,
    term
  )
    unless lecture_room_management_information_repository.is_a?(LectureRoomManagementInformationRepository)
      raise TypeError, 'lecture_room_management_information_repository must be a LectureRoomManagementInformationRepository.'
    end
    unless academic_calendar_information_repository.is_a?(AcademicCalendarInformationRepository)
      raise TypeError, 'academic_calendar_information_repository must be a AcademicCalendarInformationRepository.'
    end
    unless timetable_information_repository.is_a?(TimetableInformationRepository)
      raise TypeError, 'timetable_information_repository must be a TimetableInformationRepository.'
    end
    unless reservation_information_repository.is_a?(ReservationInformationRepository)
      raise TypeError, 'reservation_information_repository must be a ReservationInformationRepository.'
    end
    unless managed_lecture_room_information_repository.is_a?(ManagedLectureRoomInformationRepository)
      raise TypeError, 'managed_lecture_room_information_repository must be a ManagedLectureRoomInformationRepository.'
    end
    unless interactive_menu.is_a?(InteractiveMenu)
      raise TypeError, 'interactive_menu must be a InteractiveMenu.'
    end
    unless term.is_a?(Integer)
      raise TypeError, 'term must be a Integer.'
    end

    @lecture_room_management_information_repository = lecture_room_management_information_repository
    @academic_calendar_information_repository = academic_calendar_information_repository
    @timetable_information_repository = timetable_information_repository
    @reservation_information_repository = reservation_information_repository
    @managed_lecture_room_information_repository = managed_lecture_room_information_repository
    @interactive_menu = interactive_menu
    @term = term
  end

  def execute
    if (managed_lecture_room_informations = @managed_lecture_room_information_repository.find_all).empty?
      return CommandResult.new(false, false, 11)
    end
    if (academic_calendar_informations = @academic_calendar_information_repository.find_all).empty?
      return CommandResult.new(false, false, 12)
    end
    if (timetable_informations = @timetable_information_repository.find_all).empty?
      return CommandResult.new(false, false, 13)
    end
    if (reservation_informations = @reservation_information_repository.find_all).empty?
      return CommandResult.new(false, false, 14)
    end

    lecture_room_management_information_factory =
      LectureRoomManagementInformationFactory.new(
        academic_calendar_informations,
        timetable_informations,
        reservation_informations,
        managed_lecture_room_informations,
        @term
      )
    
    lecture_room_management_informations = lecture_room_management_information_factory.create_from_timetable_informations
    lecture_room_management_informations += lecture_room_management_information_factory.create_from_reservation_informations
    @lecture_room_management_information_repository.replace_all(lecture_room_management_informations)

    interactive_conflict_resolution_service = InteractiveConflictResolutionService(@interactive_menu)
    interactive_conflict_resolution_service.execute

    return CommandResult.new(false, true , 0)
  end
end
