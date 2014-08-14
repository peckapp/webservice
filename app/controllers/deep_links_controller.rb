class DeepLinksController < ApplicationController
  before_action :confirm_minimal_access, except: [:native_peck, :plain]

  def native_peck
    if mobile_request?
      # begin
        redirect_to("peckapp://")
        puts "The Status: #{response.status}"
        puts "The Message: #{response.message}"
        puts "The Body: #{response.body}"
        puts "The Response Code: #{response.response_code}"
        puts "Sent: #{response.sent?}"
      # rescue URI::Parser::InvalidURIError => encoding
      #   puts "----> the encoding 1: #{encoding} <---"
      #   redirect_to("https://itunes.apple.com/us/app/peck-williams/id702672553?mt=8")
      # end
    else
      redirect_to("https://peckapp.com")
      puts "The Status: #{response.status}"
      puts "The Message: #{response.message}"
      puts "The Body: #{response.body}"
      puts "The Response Code: #{response.response_code}"
      puts "Sent: #{response.sent?}"
    end
  end

  def plain
  end
end
