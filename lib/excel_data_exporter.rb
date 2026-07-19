require 'fileutils'
require 'rubyXL'
require_relative 'excel_data_loader' # ApplicationPathクラスを利用するため

class ExcelDataExporter
  # ApplicationPathと同じ，アプリケーションルート直下のoutputを公開する。
  OUTPUT_DIRECTORY = ApplicationPath::OUTPUT_DIRECTORY

  def initialize
  end

  def export(workbook, file_name)
    unless workbook.is_a?(RubyXL::Workbook)
      raise TypeError, 'workbook must be a RubyXL::Workbook.'
    end

    unless file_name.is_a?(String)
      raise TypeError, 'file_name must be a String.'
    end

    # ファイル名を検証し，必要ならoutputを作成したうえで固定の出力先へ書き込む。
    workbook.write(ApplicationPath.output_file_path(file_name, create_directory: true))
  end
end
