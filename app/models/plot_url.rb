class PlotUrl < ApplicationRecord


  p = PlotUrl.new
  link_1 = "https://en.wikipedia.org/wiki/The_Shining_(film)"

  link_2 = "https://en.wikipedia.org/wiki/Home_Alone"
  #p.parseHTML(link)



  def parseHTML(link)
    require 'open-uri' #open-uri stores the HTML content in a string variable
    doc = Nokogiri::HTML( open(link) )

    title = doc.title
    puts "1 - title is: " + title
    self.title = title

    puts "2 - link is: " + link
    self.link = link

    summary = doc.css('p').first
    puts "3 - summary is: " + summary
    self.summary = summary

    #skip genre for now...

    #skip cast for now...

    #plot...
    puts 'verified!!!!!!' if doc.at_css('[id="Plot"]').text.eql? 'Plot'
    #note: css returns a set with all the matching selector's elements in the DOM,
    #while at_css returns only the first matching element of the set

    plot_header = doc.at_css('[id="Plot"]')
    puts "plot_header is: " + plot_header #this is the second H2 on the page: Plot

    cast_header = doc.at_css('[id="Cast"]')
    puts "cast_header is: " + cast_header

    # from stack overflow: https://stackoverflow.com/questions/24193807/nokogiri-and-xpath-find-all-text-between-two-tags

    intersection = doc.xpath('//h2[2]/preceding::text()[ count( . | //h2[1]/following::text()) = count(//h2[1]/following::text()) ]')

    plot_text = intersection.to_s.split('Plot[edit]')[1]
    self.plot = plot_text

    #plot_para_1 = doc.css('p')[7].children.text #need to abstract this...
    #this won't always be the 8th paragraph on the page...
    #puts "plot_para_1 is: " + plot_para_1

    #try plot_header.next ?!?!?!
    plot_para_1 = plot_header.parent.next_element #the parent of H2 Plot's next element is first paragraph of plot...

    plot_para_2 = plot_para_1.next_element

    #when does this end??? how do i abstract this... won't always be same number of paragraphs...

    byebug #<<<<-------- byebug works! keep on byebubbing...

    #self.plot = plot_para_1

    self.save
  end

  #function to call from controller, to call function above...
  def parse_that_ish(link)
    self.parseHTML(link)
    self.save
  end

  # def example
  #   require 'open-uri'
  #
  #   doc = Nokogiri::HTML(open('http://www.nokogiri.org/tutorials/installing_nokogiri.html'))
  #
  #   puts "### Search for nodes by css"
  #   doc.css('nav ul.menu li a', 'article h2').each do |link|
  #     puts link.content
  #   end
  #
  #   puts "### Search for nodes by xpath"
  #   doc.xpath('//nav//ul//li/a', '//article//h2').each do |link|
  #     puts link.content
  #   end
  #
  #   puts "### Or mix and match."
  #   doc.search('nav ul.menu li a', '//article//h2').each do |link|
  #     puts link.content
  #   end
  #
  # end

end
