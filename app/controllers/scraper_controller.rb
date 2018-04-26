require 'open-uri'
require 'openssl'
require 'watir'

class ScraperController < ApplicationController
  def scrape
    b = Watir::Browser.new :chrome, headless: true
    b.goto "https://www.livearia.com/availability"
    doc ||= Nokogiri::HTML(b.html)
    available_units = doc.css('.available-unit a')
    available_units.each do |unit|
      Listing.create(
        unit_number: unit.css('.listing-unit-num').text, 
        unit_type: unit.xpath('//*[@id="unit-availability-data"]/div[1]/a/h3/text()[1]').text, 
        sq_feet: unit.xpath('//*[@id="unit-availability-data"]/div[1]/a/h3/text()[3]').text.split(" ")[0], 
        rent_cost: unit.xpath('//*[@id="unit-availability-data"]/div[1]/a/h3/text()[4]').text , 
        availability: unit.css('.listing-unit-date').text,
        source: "Aria"
      )
    end
  end
end