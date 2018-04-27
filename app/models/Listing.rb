class Listing < ActiveRecord::Base
  belongs_to :location
  has_many :days

  def self.sort_avail_then_floorplan
    Listing.order("
      CASE
        WHEN availability LIKE 'Available Now' THEN 1
        WHEN floorplan LIKE 'S1' THEN 2
        WHEN floorplan LIKE 'S2' THEN 3
        WHEN floorplan LIKE 'A1' THEN 4
        WHEN floorplan LIKE 'A2' THEN 5
        WHEN floorplan LIKE 'A3' THEN 6
        WHEN floorplan LIKE 'A4' THEN 7
        WHEN floorplan LIKE 'B1' THEN 8
        WHEN floorplan LIKE 'B2' THEN 9
        WHEN floorplan LIKE 'B3' THEN 10
        WHEN floorplan LIKE 'B4' THEN 11
        WHEN floorplan LIKE 'S2L' THEN 12
        WHEN floorplan LIKE 'A1L' THEN 13
        WHEN floorplan LIKE 'A2L' THEN 14
        WHEN floorplan LIKE 'A3L' THEN 15
        WHEN floorplan LIKE 'B2L' THEN 16
        WHEN floorplan LIKE 'B3L' THEN 17
        WHEN floorplan LIKE 'B4L' THEN 18
        ELSE 19
      END,
      availability,
      floorplan
    ")
  end

  def get_unique_dates
    listing = Listing.find_by(id: self.id)
    day_records = listing.days.select(:date).distinct
    day_records.map do |day|
      day.date
    end
  end

  def get_floorplan_count
    floorplan_hash = {
      "S1": 0, 
      "S2": 0, 
      "A1": 0, 
      "A2": 0, 
      "A3": 0, 
      "A4": 0, 
      "B1": 0, 
      "B2": 0, 
      "B3": 0, 
      "B4": 0, 
      "S2L": 0, 
      "A1L": 0, 
      "A2L": 0, 
      "A3L": 0, 
      "B2L": 0, 
      "B3L": 0, 
      "B4L": 0
    }
    floorplan_hash.stringify_keys!
    floorplan_hash.map do |key,value|
      floorplan_hash[key] = Listing.where(floorplan: "#{key}")
    end
  end
end
