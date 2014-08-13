class DeepLinksController < ApplicationController
  before_action :confirm_minimal_access, except: :native_peck

  def native_peck
    if mobile_request?
      begin
        the_uri = unshorten("peckapp://")
        response = HTTParty.get(the_uri, limit: 50)
      rescue URI::InvalidURIError => encoding
        redirect_to("https://itunes.apple.com/us/app/peck-williams/id702672553?mt=8")
      else
        redirect_to("peckapp://")
      end
    else
      redirect_to("peckapp://")
    end

    def unshorten(uri)
      begin
        response = HTTParty.get(uri, limit: 50)
      rescue URI::InvalidURIError => error
        bad_uri = error.message.match(/^bad\sURI\(is\snot\sURI\?\)\:\s(.*)$/)[1]
        good_uri = URI.encode bad_uri
        response = self.unshorten good_uri
      end
      response
    end
  end
end
