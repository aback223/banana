require 'open-uri'
require 'openssl'
require 'watir'

class ScraperController < ApplicationController
  def scrape
  end

  def scrape_data
    b = Watir::Browser.new :chrome, headless: true
    b.goto "https://www.livearia.com/availability"
    doc ||= Nokogiri::HTML(b.html)
    available_units = doc.css('.available-unit a')
    location = Location.create(city_state: "Cerritos, CA")
    available_units.each do |unit|
      listing = Listing.create(
        unit_number: unit.css('.listing-unit-num').text, 
        unit_type: unit.css('.listing-unit-info').children[0].text, 
        floorplan: unit.css('.listing-unit-image img').attr("src").text,
        sq_feet: unit.css('.listing-unit-info').children[4].text.split(" ")[0], 
        availability: unit.css('.listing-unit-date').text,
        source: "Aria Apartments"
      )
      location.listings.push(listing)
    end
    b.close
    flash[:notice] = "Done scraping data"
    render :scrape
  end

  def scrape_day
    b = Watir::Browser.new :chrome, headless: true
    b.goto "https://www.livearia.com/availability"
    doc ||= Nokogiri::HTML(b.html)
    available_units = doc.css('.available-unit a')
    available_units.each do |unit|
      listing = Listing.find_by(unit_number: unit.css('.listing-unit-num').text)
      day = Day.create(date: Date.today.strftime("%m/%d/%Y"), rent: unit.css('.listing-unit-info').children[6].text) 
      listing.days.push(day)
    end
    b.close
    flash[:notice] = "Done scraping daily rent"
    redirect_to scraper_path
  end
end