class ListingsController < ApplicationController
  def index
    @listings = Listing.sort_avail_then_floorplan
    respond_to do |format|
      format.html {render :index}
      format.json {render json: @listings}
    end
  end
end