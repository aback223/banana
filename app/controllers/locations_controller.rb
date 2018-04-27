class LocationsController < ApplicationController
  def index
    @locations = Location.all
    @days = Day.unique_dates
    respond_to do |format|
      format.html {render :index}
      format.json {render json: @locations, include: '**'}
    end
  end
end