class LectureRoomManagementExcelFormatter
  def format(lecture_room_management_information)
    unless lecture_room_management_information.is_a?(LectureRoomManagementInformation)
      raise TypeError, "lecture_room_management_information must be a LectureRoomManagementInformation"
    end 

    subject = lecture_room_management_information.subject
    user = lecture_room_management_information.user

    return "#{subject}　#{user}"
  end
end