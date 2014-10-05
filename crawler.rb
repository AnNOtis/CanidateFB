require "Koala"
require 'open-uri'
require "CSV"
require File.join(File.dirname(__FILE__), 'config')

CATEGORY_FILTER = ['politician' , 'public figure' , 'news/media website']
FILE_NAME = "鄉鎮市長"
INPUT_PATH = "data/#{FILE_NAME}.csv"
OUTPUT_PATH = "data/fb_#{FILE_NAME}.csv"
@graph = Koala::Facebook::API.new(ACCESS_TOKEN)

def process(path)

  unless File.file?(OUTPUT_PATH)
    File.new(OUTPUT_PATH, "w+")
  end
  output_csv = CSV.open(OUTPUT_PATH, "wb")
  count = 0
  begin
    CSV.foreach(path) do |row|
      # count += 1
      # if count >= 317
      output = fetch_fb(*row)
      output_csv << output
      delay()
      # end
    end
    output_csv.close()
  rescue
  end

end

def fetch_fb(area, user, party, mystery_number)
    fb_links = []
    puts "===============#{user}=================="
    puts '::PAGE::'
    result_pages =  @graph.search( user, type: 'page' )[0,3]
    result_pages.select! do |page|
      category = page["category"].downcase
      if CATEGORY_FILTER.include? category
        fb_links << page["name"]
        fb_links << "http://www.facebook.com/#{page["id"]}"
      end
    end
    puts result_pages

    puts '::GROUP::'
    result_groups = @graph.search( user, type: 'group' )[0,3]
    result_groups.each do |group|
      fb_links << group["name"]
      fb_links << "http://www.facebook.com/#{group["id"]}"
    end
    puts result_groups

    [area, user, party] + fb_links
end

def delay
  gate = 20
  random = rand(100)

  if random < gate
    r = rand(10)
    puts "...Delay...#{r}s"
    sleep(r)
  else
    r = rand(1..3)
    puts "...Delay...#{r}s"
    sleep(r)
  end
end
process(INPUT_PATH)