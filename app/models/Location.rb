class Location < ActiveRecord::Base
  has_many :listings
  has_many :days, through: :listings

  def get_unique_dates
    location = Location.find_by(id: self.id)
    location.days.select(:date).distinct
  end
end