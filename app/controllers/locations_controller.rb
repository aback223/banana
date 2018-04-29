class LocationsController < ApplicationController
  def index
    @location = Location.first
    @listings = Listing.sort_avail_then_floorplan
    respond_to do |format|
      format.html {render :index}
      format.json {render json: @locations}
    end
  end
end