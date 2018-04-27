class DaysController < ApplicationController
  def index
    @days = Day.all
  end
end