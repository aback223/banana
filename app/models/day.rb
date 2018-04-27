class Day < ActiveRecord::Base
  belongs_to :listing

  def self.unique_dates
    Day.select(:date).uniq
  end
end