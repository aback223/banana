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
        unit_type: unit.css('.listing-unit-info').children[2].text,
        image: unit.css('.listing-unit-image img').attr("src").text,
        floorplan: unit.css('.listing-unit-info').children[0].text,
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
      Listing.all.each do |listing|
        if listing.unit_number == unit.css('.listing-unit-num').text
          new_day = Day.new(date: Date.today.strftime("%m/%d/%Y"), rent: unit.css('.listing-unit-info').children[6].text) 
          if !listing.days.empty?
            listing.days.each do |day|
              if listing.get_unique_dates.include?(Date.today.strftime("%m/%d/%Y")) && (day.rent != new_day.rent)
                day.update(rent: unit.css('.listing-unit-info').children[6].text)
              elsif listing.get_unique_dates.exclude?(Date.today.strftime("%m/%d/%Y"))
                new_day.save
                listing.days.push(new_day) 
              end
            end
          elsif listing.days.empty?
            new_day.save
            listing.days.push(new_day) 
          end
        end
      end
    end
    b.close
    flash[:notice] = "Done scraping daily rent"
    redirect_to scraper_path
  end

  def check_availability
    b = Watir::Browser.new :chrome, headless: true
    b.goto "https://www.livearia.com/availability"
    doc ||= Nokogiri::HTML(b.html)
    available_units = doc.css('.available-unit a')
    unit_array = []
    available_units.each do |unit|
      unit_array << unit.css('.listing-unit-num').text
    end
    Listing.all.each do |listing|
      if unit_array.exclude?(listing.unit_number)
        listing.update(availability: "Not Available")
        new_day = Day.new(date: Date.today.strftime("%m/%d/%Y"), rent: " ") 
        if !listing.days.empty? && listing.get_unique_dates.exclude?(Date.today.strftime("%m/%d/%Y"))
          new_day.save
          listing.days.push(new_day) 
        end
      end
    end
    b.close
    flash[:notice] = "Done checking availability"
    redirect_to scraper_path
  end
end