require "Koala"
require 'open-uri'
require "CSV"
require File.join(File.dirname(__FILE__), 'config')

CATEGORY_FILTER = ['politician' , 'public figure' , 'news/media website']
FILE_NAME = "直轄市長"
PATH = "data/#{FILE_NAME}.csv"
OUTPUT_PATH = "data/#{FILE_NAME}_fb.csv"
@graph = Koala::Facebook::API.new(ACCESS_TOKEN)

def read(path)
  unless File.file?(OUTPUT_PATH)
    File.new(OUTPUT_PATH, "w+")
  end
  output_csv = CSV.open(OUTPUT_PATH, "wb")

  CSV.foreach(path) do |row|
    area, user, party = row
    fb_links = []
    puts "===============#{user}=================="
    puts '::PAGE::'
    result_pages =  @graph.search( user, type: 'page' )
    result_pages.select! do |page|
      category = page["category"].downcase
      if CATEGORY_FILTER.include? category
        fb_links << page.name
        fb_links << "http://www.facebook.com/#{page.id}"
      end
    end
    puts result_pages

    puts '::GROUP::'
    result_groups = @graph.search( user, type: 'group' )
    result_groups.each do |group|
      fb_links << group.name
      fb_links << "http://www.facebook.com/#{group.id}"
    end
    puts result_groups
    output_csv << (row + fb_links)
  end

end

def output(area, user, party, fb_links)
  CSV.open("path/to/file.csv", "wb") do |csv|
  csv << ["row", "of", "CSV", "data"]
  csv << ["another", "row"]
  end
end



read("data/直轄市長.csv")