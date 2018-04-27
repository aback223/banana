class DaysController < ApplicationController
  def index
    @days = Day.all
    render json: @days
  end
end