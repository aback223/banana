class DailyDataController < ApplicationController
  def calcAndAdd
    DailyData.calcAndSave
    flash[:notice] = "Done adding totals"
    redirect_to scraper_path
  end
end