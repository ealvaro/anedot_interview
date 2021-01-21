require 'httparty'
require 'nokogiri'

class Scraper

  URL = "https://seattle.craigslist.org/search/cta?query=jeep"

  attr_accessor :parse_page

  def initialize
    doc = HTTParty.get(URL)
    @parse_page ||= Nokogiri::HTML(doc)
  end

  scraper = Scraper.new
  puts scraper.parse_page
end