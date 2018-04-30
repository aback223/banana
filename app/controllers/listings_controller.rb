class ListingsController < ApplicationController
  def index
    @listings = Listing.all
    respond_to do |format|
      format.html {render :index}
      format.json {render json: @listings}
    end
  end
end