require "Koala"
require 'open-uri'
require "CSV"
ACCESS_TOKEN = "CAACEdEose0cBALQTuPVFPV1Bsuu0D4hreZBye9RhFriVQ0zerjVZCpqzyma2IyLHvV7ZAwJZBGa3BTZCMvxy4yupFLWwnUGNrgoBz5OvZAdJFYHi81qApQS5pzLzzLZC59jjCqoSZBh7yldpLbKDRwK8i8bYW3kHFK3pYPjr3Qgr8gLHJF7sJqsAQyrRKyhWWw8ASCbpZANh68riqLMBUkPdCCQsvz8aqI50ZD"
@graph = Koala::Facebook::API.new(ACCESS_TOKEN)
CATEGORY_FILTER = ['politician' , 'public figure' , 'news/media website']

def read(url)
  CSV.new(open(url)).each do |row|
    # use row here...
    area, user, party = row

    puts "===============#{user}=================="
    puts '::PAGE::'
    result_pages =  @graph.search( user, type: 'page' )
    result_pages.select! do |page|
      category = page["category"].downcase
      CATEGORY_FILTER.include? category
    end
    puts result_pages
    puts '::GROUP::'
    result_groups = @graph.search( user, type: 'group' )

  end
end



read("https://raw.githubusercontent.com/kiang/elections/master/Console/Command/data/2014_candidates/%E9%84%89%E9%8E%AE%E5%B8%82%E9%95%B7.csv")