class CsvExport < ActiveRecord::Base

  def self.to_csv(options: {})
    CSV.generate(options) do |csv|
      csv.add_row self.         #header
      all.each do |foo|                 #row value iteration
        values = foo.attributes.values
        csv.add_row values 
      end
    end
  end

  def self.header_names
    header = ["Property", "Unit Type", "Floor Plan", "Unit #", "SF", "Status"]
    date_headers = Day.get_unique_dates #descending order
    header + date_headers
  end
end