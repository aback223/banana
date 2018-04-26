class LocationController < ApplicationController
  def index
    @locations = Location.all
    respond_to do |format|
      format.html {render :index}
      format.json {render json: @locations}
    end
  end
end