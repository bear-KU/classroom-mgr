class ExcelDataExporter
  def export(workbook,file_name)
    unless workbook.is_a?(RubyXL::Workbook)
      raise TypeError, "workbook must be a RubyXL::Workbook"
    end     

    unless file_name.is_a?(String)
      raise TypeError, "file_namw must be a String"
    end     

    workbook.write("#{file_name}.xlsx")
  end
end