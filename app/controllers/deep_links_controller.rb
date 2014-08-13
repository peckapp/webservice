class DeepLinksController < ApplicationController
  before_action :confirm_minimal_access, except: :native_peck

  def native_peck
    if mobile_request?
      begin
        response = HTTParty.get("peckapp://", limit: 50)
      rescue URI::InvalidURIError => encoding
        redirect_to("https://itunes.apple.com/us/app/peck-williams/id702672553?mt=8")
      else
        redirect_to("peckapp://")
      end
    else
      redirect_to("http://peckapp.com")
    end
  end
end
