class LocationsController < ApplicationController
  def index
    @locations = Location.all
    respond_to do |format|
      format.html {render :index}
      format.json {render json: @locations, include: '**'}
    end
  end
end