class PlotUrl < ApplicationRecord


  p = PlotUrl.new
  link_1 = "https://en.wikipedia.org/wiki/The_Shining_(film)"

  link_2 = "https://en.wikipedia.org/wiki/Home_Alone"

  link_3 = "https://en.wikipedia.org/wiki/El_Topo"

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

#    from stack overflow: https://stackoverflow.com/questions/24193807/nokogiri-and-xpath-find-all-text-between-two-tags
#    this works, but is slow... see if there's a faster way...
#    intersection = doc.xpath('//h2[2]/preceding::text()[ count( . | //h2[1]/following::text()) = count(//h2[1]/following::text()) ]')
#    plot_text = intersection.to_s.split('Plot[edit]')[1]
#    self.plot = plot_text

    the_first = plot_header.parent #plot comes after H2 Plot
    the_last = cast_header.parent #plot comes before H2 Cast

    plot_array = collect_between(the_first, the_last)
    plot_array.shift #remove "Plot[edit]" from plot_array
    plot_array.pop #remove "Cast[edit]" from plot_array

    plot_array = plot_array.map { |element| "text: " + element.text  } #keep working on this, maybe make another method that gets called...

    puts "plot_array contains: " #wanna check it out in the console, but don't need this...
    plot_array.map { |element| puts element }

    #self.save  #this will save each created plot to the database...
    file_name = title
    file_content = plot_array
    create_file(file_name, file_content) #calling method below with two arguments

    #byebug #<<<<-------- byebug works! keep on byebubbing...
  end


  #got this from here: https://stackoverflow.com/questions/820066/nokogiri-select-content-between-element-a-and-b
  def collect_between(first, last)
    puts "calling collect_between..."
    result = [first]
    until first == last
      first = first.next_element
      result << first
    end
    result
  end

  #calling at end of function above...
  def create_file(file_name, file_content)
    require 'fileutils'
    file_name = file_name + ".rb"
    somefile = File.open(file_name, "w")
    somefile.puts file_content
    somefile.close
    puts "created file..."
    return "created file...!!!!!"
  end


  #function to call from controller, to call function above...
  def parse_that_ish(link)
    self.parseHTML(link)
    self.save
  end

end #end of class
