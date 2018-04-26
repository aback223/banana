class LocationSerializer < ActiveModel::Serializer
  attributes :id, :city_state
  has_many :listings
end
