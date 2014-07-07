# Code for the clockwork gem that runs scheduled tasks
# https://github.com/tomykaira/clockwork

require 'clockwork'
module Clockwork

  configure do |config|
    config[:sleep_timeout] = 5
    #config[:logger] = Logger.new(Rails.root.join('log/clockwork.log'))
    config[:tz] = 'EST'
  end

  handler do |job|
    puts "Running #{job}"
  end

  # handler receives the time when job is prepared to run in the 2nd argument
  # handler do |job, time|
  #   puts "Running #{job}, at #{time}"
  # end

  every(10.seconds, 'Tasks::RssScraperController.scrape')

end
