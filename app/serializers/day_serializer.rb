class DaySerializer < ActiveModel::Serializer
  attributes :id, :date, :rent, :listing_id
  belongs_to :listing
end
