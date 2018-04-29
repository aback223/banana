class Day < ActiveRecord::Base
  belongs_to :listing

  def self.floorplan_hash
    hash = {
      "S1": [], 
      "S2": [], 
      "A1": [], 
      "A2": [], 
      "A3": [], 
      "A4": [], 
      "B1": [], 
      "B2": [], 
      "B3": [], 
      "B4": [], 
      "S2L": [], 
      "A1L": [], 
      "A2L": [], 
      "A3L": [], 
      "B2L": [], 
      "B3L": [], 
      "B4L": []
    }
    hash.stringify_keys!
  end

  def self.get_unique_dates
    self.distinct.pluck(:date)
  end

  def self.calcAvg
    hash = Day.floorplan_hash
    hash.each do |key, value|
      Day.all.each do |day|
        if key == day.listing.floorplan && day.date == Date.today.strftime("%m/%d/%Y") && day.listing.availability != "Unavailable"
          hash[key] << day.rent.tr('$', '').to_i
        end
      end
    end
    hash.each do |key, value|
      if !value.empty?
        hash[key] = (value.inject(:+)/value.size)
      end
    end
    hash
  end
end