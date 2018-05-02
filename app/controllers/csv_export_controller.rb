class CsvExportController < ApplicationController
  def export
    @data = Listing.all
    respond_to do |format|
      format.html { redirect_to root_url}
      format.csv {send_data @data.to_csv}
    end
  end
end