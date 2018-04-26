require 'open-uri'
require 'openssl'
require 'watir'

class ScraperController < ApplicationController
  def scrape
    b = Watir::Browser.new :chrome, headless: true
    b.goto "https://www.livearia.com/availability"
    doc ||= Nokogiri::HTML(b.html)
    available_units = doc.css('.available-unit a')
    location = Location.create(city_state: "Cerritos, CA")
    available_units.each do |unit|
      listing = Listing.create(
        unit_number: unit.css('.listing-unit-num').text, 
        unit_type: unit.css('.listing-unit-info').children[0].text, 
        sq_feet: unit.css('.listing-unit-info').children[4].text.split(" ")[0], 
        rent_cost: unit.css('.listing-unit-info').children[6].text, 
        availability: unit.css('.listing-unit-date').text,
        source: "Aria"
      )
      location.listings.push(listing)
    end
    b.close
  end
end