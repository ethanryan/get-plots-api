class PlotUrl < ApplicationRecord

  link = "https://en.wikipedia.org/wiki/The_Shining_(film)"

  def parseHTML(link)
    require 'open-uri'
    doc = Nokogiri::HTML( open(link) )
  end

  def parse_that_ish(link)
    self.parseHTML(link)
    self.save
  end

end
