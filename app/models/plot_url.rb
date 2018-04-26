class PlotUrl < ApplicationRecord

  link = "https://en.wikipedia.org/wiki/The_Shining_(film)"

  def parseHTML(link)
    doc = Nokogiri::HTML( open(link) )
  end

end
