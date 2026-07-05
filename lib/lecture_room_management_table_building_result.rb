class LectureRoomManagementTableBuildingResult
  attr_reader :workbook, :row_map, :column_map
  
  def initialize(workbook,row_map,column_map)
    unless workbook.is_a?(RubyXL::Workbook)
      raise TypeError, "workbook must be a RubyXL::Workbook"
    end 

    unless row_map.is_a?(Hash)
      raise TypeError, "row_map must be a Hash"
    end 

    unless column_map.is_a?(Hash)
      raise TypeError, "column must be a Hash"
    end 

    @workbook = workbook
    @row_map = row_map
    @column_map = column_map
  end
end