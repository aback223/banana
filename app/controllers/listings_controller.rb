class ListingsController < ApplicationController
  def index
    @listings = Listing.all
    render json: @listings
  end
end