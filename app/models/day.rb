class Day < ActiveRecord::Base
  belongs_to :listing

  def self.unique_dates
    self.select(:date).distinct
  end
end