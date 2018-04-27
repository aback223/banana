class Listing < ActiveRecord::Base
  belongs_to :location
  has_many :days
end
