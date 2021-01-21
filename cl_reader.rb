require 'httparty'
require 'nokogiri'

class Scraper

  URL = "https://seattle.craigslist.org/search/cta?query=jeep"

  attr_accessor :parse_page

  def initialize
    doc = HTTParty.get(URL)
    @parse_page ||= Nokogiri::HTML(doc)
  end

  def get_dates
    item_container.css(".result-date").children.map { |d| d.text }.compact
  end

  def get_titles
    item_container.css(".result-heading").css(".result-title").children.map { |t| t.text }.compact
  end

  def extract_year (title)
    if title[/\b\d{4}\b/]          # 4 digit years if included
      title[/\b\d{4}\b/]
    else
      if title[/\b\d{2}\b/]        # Had to add last century digits for 2 digit years
        "19" + title[/\b\d{2}\b/]
      else
        "None"                     # "None" for the missing ones
      end
    end
  end

  def get_years (titles)
    titles.map { |t| extract_year(t) }
  end

private

  def item_container
    parse_page.css(".result-info")   # The common HTML element for the page results
  end

  scraper = Scraper.new
  # puts scraper.parse_page
  dates = scraper.get_dates
  titles = scraper.get_titles
  years = scraper.get_years(titles)

  # OUTPUT
  (0...titles.size).each do |i|
    # puts "#{i} - "
    puts "#{years[i]} - #{dates[i]} - #{titles[i]}"
  end
end