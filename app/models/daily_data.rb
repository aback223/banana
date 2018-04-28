class DailyData < ActiveRecord::Base
  def self.calcAndSave
    if DailyData.where(date: Date.today.strftime("%m/%d/%Y")).empty?
      occupancy = Listing.calc_ttlVacantPct
      leased = Listing.ttlExpPct
      new = DailyData.create(date: Date.today.strftime("%m/%d/%Y"), occupancy: occupancy, leased: leased)
    end
  end

  def self.row_headers 
    hash = ["Occupancy", "Leased"]
  end
end