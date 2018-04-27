class ListingSerializer < ActiveModel::Serializer
  attributes :id, :unit_number, :unit_type, :sq_feet, :availability, :source, :floorplan
  has_many :days
end
