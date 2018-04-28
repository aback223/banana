class Source < ActiveRecord::Base
  has_many :dates
  belongs_to :location
end