require 'httparty'
require 'nokogiri'
require 'money'

class Scraper

  TAX_RATE = 8.9
  URL = "https://seattle.craigslist.org/search/cta?query=jeep"
  YEAR_COL = 4
  DATE_COL = 8
  TITLE_COL = 76
  PRICE_COL = 12

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

  def get_prices
    item_container.css(".result-meta").css(".result-price").children.map { |p| p.text }.compact
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

  # Money configurations
  I18n.config.available_locales = :en
  Money.rounding_mode = 1
  Money.locale_backend = :i18n
  I18n.locale = :en

  scraper = Scraper.new
  dates = scraper.get_dates
  titles = scraper.get_titles
  prices = scraper.get_prices
  years = scraper.get_years(titles)                                   # Years are inside the Titles
  prices_total = prices.map { |p| p.gsub(/\D/,'').to_i}.reduce(0, :+) # Get rid of currency formatting and calculate total
  tax_total = prices_total * TAX_RATE / 100

  # OUTPUT
  (0...titles.size).each do |i|
    # puts "#{i} - "
    puts "%-#{YEAR_COL}s"  % years[i] + " - %-#{DATE_COL}s" % dates[i] + " - %-#{TITLE_COL}s" % titles[i] + " - %-#{PRICE_COL}s" % prices[i]
  end
  puts "_______________________"
  puts "TOTAL = #{Money.new(prices_total * 1000, "USD").format(symbol: true)}"
  puts "TAX   = #{Money.new(tax_total * 1000, "USD").format(symbol: true)}"

end