class LocationsController < ApplicationController
  def index
    @locations = Location.all
    @listings = Listing.sort_avail_then_floorplan
    respond_to do |format|
      format.html {render :index}
      format.json {render json: @locations}
    end
  end
end