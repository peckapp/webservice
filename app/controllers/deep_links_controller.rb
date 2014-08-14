class DeepLinksController < ApplicationController
  before_action :confirm_minimal_access, except: [:native_peck]

  def native_peck
    redirect_to("http://peckapp.com") unless mobile_request?
  end
end
