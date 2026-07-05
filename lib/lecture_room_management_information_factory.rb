class LectureRoomManagementInformationFactory
  def initialize(
    academic_calendar_informations,
    timetable_informations,
    reservation_informations,
    managed_lecture_room_informations,
    term
  )
    unless academic_calendar_informations.is_a?(Array)
      raise TypeError, 'academic_calendar_informations must be a Array.'
    end
    unless timetable_informations.is_a?(Array)
      raise TypeError, 'timetable_informations must be a Array.'
    end
    unless reservation_informations.is_a?(Array)
      raise TypeError, 'reservation_informations must be a Array.'
    end
    unless managed_lecture_room_informations.is_a?(Array)
      raise TypeError, 'managed_lecture_room_informations must be a Array.'
    end
    unless term.is_a?(Integer)
      raise TypeError, 'term must be a Integer.'
    end

    @academic_calendar_informations = academic_calendar_informations
    @timetable_informations = timetable_informations
    @reservation_informations = reservation_informations
    @managed_lecture_room_informations = managed_lecture_room_informations
    @term = term
  end

  def create_from_timetable_informations
    lecture_room_management_informations = []
    
    @timetable_informations.each do |timetable_information|
      lecture_room_management_informations +=
        create_from_timetable_information(timetable_information)
    end

    return lecture_room_management_informations
  end

  def create_from_reservation_informations
    lecture_room_management_informations = []

    @reservation_informations.each do |reservation_information|
      if (lecture_room_management_informations_of_reservation_information = create_from_reservation_information(reservation_information)) != nil
        lecture_room_management_informations +=
          lecture_room_management_informations_of_reservation_information
      end
    end

    return lecture_room_management_informations
  end

  def create_from_timetable_information(timetable_information)
    unless timetable_information.is_a?(TimetableInformation)
      raise TypeError, 'timetable_information must be a TimetableInformation.'
    end
    
    filtered_academic_calendar_informations = 
      @academic_calendar_informations.select do |academic_calendar_information|
        academic_calendar_information.day_of_the_week == timetable_information.day_of_the_week &&
        academic_calendar_information.term == timetable_information.term
      end
    
    lecture_room_management_informations = []
    filtered_academic_calendar_informations.each do |information|
      timetable_information.room_names.each do |room_name|
        lecture_room_management_informations.append(
          LectureRoomManagementInformation.new(
            date: information.date,
            day_of_the_week: information.day_of_the_week,
            term: information.term,
            periods: timetable_information.periods,
            room_name: room_name,
            subject: timetable_information.subject,
            user: timetable_information.user,
            comment: ""
          )
        )
      end
    end

    return lecture_room_management_informations
  end

  def create_from_reservation_information(reservation_information)
    unless reservation_information.is_a?(ReservationInformation)
      raise TypeError, 'reservation_information must be a ReservationInformation.'
    end

    filtered_academic_calendar_informations =
      @academic_calendar_informations.select do |academic_calendar_information|
        academic_calendar_information.date == reservation_information.date
      end
    
    if filtered_academic_calendar_informations.length != 1
      raise '該当するAcademicCalendarInformationが1つもないか，複数あります．'
    end

    filtered_academic_calendar_information = filtered_academic_calendar_informations.first

    lecture_room_management_informations = []
    reservation_information.room_names.each do |room_name|
      lecture_room_management_informations.append(
        LectureRoomManagementInformation.new(
          date: reservation_information.date,
          day_of_the_week: filtered_academic_calendar_information.day_of_the_week,
          term: filtered_academic_calendar_information.term,
          periods: reservation_information.periods,
          room_name: room_name,
          subject: reservation_information.subject,
          user: reservation_information.user,
          comment: ""
        )
      )
    end
    
    return lecture_room_management_informations
  end
end
