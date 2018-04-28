class Date < ActiveRecord::Base
  belongs_to :source
  has_many :aria_reports
end