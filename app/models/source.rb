class Source < ActiveRecord::Base
  has_many :dates
  belongs_to :location
  has_one :aria_static_data
end