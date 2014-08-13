class DeepLinksController < ApplicationController
  before_action :confirm_minimal_access, except: [:native_peck]

  def native_peck
    if mobile_request?
      redirect_to("peckapp://")
    else
      redirect_to("http://peckapp.com")
    end
  end
end
