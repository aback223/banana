class Listing < ActiveRecord::Base
  belongs_to :location
  has_many :days

  def self.floorplan_hash
    hash = {
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
    hash.stringify_keys!
  end

  def self.total_by_floorplan
    total_units = {
      "S1": 5, 
      "S2": 9, 
      "A1": 39, 
      "A2": 29, 
      "A3": 12, 
      "A4": 7, 
      "B1": 12, 
      "B2": 45, 
      "B3": 5, 
      "B4": 6, 
      "S2L": 3, 
      "A1L": 1, 
      "A2L": 6, 
      "A3L": 4, 
      "B2L": 10, 
      "B3L": 2, 
      "B4L": 2
    }
    total_units.stringify_keys!
  end

  def self.hash_with_arrays
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

  def self.calc_totalUnits
    self.total_by_floorplan.values.reduce(:+)
  end

  def self.sort_avail_then_floorplan
    self.order("
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

  def self.by_floorplan
    hash = self.hash_with_arrays
    hash.each do |key,value|
      Listing.all.each do |listing|
        if listing.availability != "Not Available" && listing.floorplan == key
          hash[key] << listing
        end
      end
    end
    hash
  end

  def self.exposureTtl
    self.calc_totalVacantNum + self.totalAvailNum
  end

  def self.ttlExpPct
    '%0.1f' % ((Listing.exposureTtl.to_f/Listing.calc_totalUnits.to_f) * 100)
  end

  def self.vacant_num
    hash = self.floorplan_hash
    hash.each do |key,value|
      self.all.each do |listing|
        if key == listing.floorplan && listing.availability == "Available Now"
          hash[key] +=1
        end
      end
    end
    hash
  end

  def self.calc_totalVacantNum
    self.vacant_num.values.reduce(:+)
  end

  def self.calc_vacantPct
    hash = self.floorplan_hash
    self.total_by_floorplan.each do |unit, total|
      self.vacant_num.each do |unitName, vacant|
        if unit == unitName
          hash["#{unit}"] = "#{('%0.2f' % ((vacant.to_f/total.to_f) * 100))}" + "%"
        end
      end
    end
    hash
  end

  def self.calc_ttlVacantPct
    '%0.1f' % ((self.calc_totalVacantNum.to_f/self.calc_totalUnits.to_f) * 100)
  end

  def self.calc_availNum
    hash = self.floorplan_hash
    hash.each do |key,value|
      self.all.each do |listing|
        if key == listing.floorplan && listing.availability.include?("/")
          hash[key] += 1
        end
      end
    end
    hash
  end

  def self.totalAvailNum
    self.calc_availNum.values.reduce(:+)
  end

  def self.calc_availPct
    hash = self.floorplan_hash
    self.total_by_floorplan.each do |unit, total|
      self.calc_availNum.each do |unitName, available|
        if unit == unitName
          hash[unit] = "#{('%0.2f' % ((available.to_f/total.to_f) * 100))}" + "%"
        end
      end
    end
    hash
  end

  def self.availPct
    '%0.1f' % ((self.totalAvailNum.to_f/self.calc_totalUnits.to_f) * 100)
  end

  def self.exposure_pct
    hash = self.floorplan_hash
    self.total_by_floorplan.each do |unit, total|
      self.by_floorplan.each do |unitName, exp_num|
        if unit == unitName && exp_num != 0
          hash[unit] = "#{('%0.2f' % ((exp_num.count.to_f/total.to_f) * 100))}" + "%"
        end
      end
    end
    hash
  end

  def self.calcMax
    hash = self.floorplan_hash
    hash.each do |key, value|
      listings = self.where(floorplan: key)
      listings.each do |listing|
        rent = listing.days.last.rent.tr('$', '').to_i
        if rent > hash[key]
          hash[key] = rent
        end
      end
    end
    hash
  end

  def self.calcMin
    hash = self.floorplan_hash
    hash.each do |key, value|
      listings = self.where(floorplan: key)
      listings.each do |listing|
        rent = listing.days.last.rent.tr('$', '').to_i
        if hash[key] == 0
          hash[key] = rent
        elsif rent < hash[key]
          hash[key] = rent
        end
      end
    end
    hash
  end
end
