class Location < ActiveRecord::Base
  has_many :listings
  has_many :days, through: :listings
end