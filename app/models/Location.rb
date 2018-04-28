class Location < ActiveRecord::Base
  has_many :listings
  has_many :days, through: :listings

  def get_unique_dates
    Location.find_by(id: self.id).days.select(:date).distinct.pluck(:date)
  end
end