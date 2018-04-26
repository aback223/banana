class ListingController < ApplicationController
  def index
    @listings = Listing.all
  end
end