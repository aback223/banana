class CsvExportController < ApplicationController
  def export
    @data 
    respond_to do |format|
      format.html { redirect_to root_url}
      format.csv {send_data @data.to_csv}
    end
  end
end