class DeepLinksController < ApplicationController
  before_action :confirm_minimal_access, except: [:native_peck, :desktop_event]

  def native_peck
    if apple_request?
      redirect_to apple_deep_links_url
    elsif android_request?
      redirec_to android_deep_links_url
    else
      @simple_event = SimpleEvent.find(61)
    end
  end

  def apple
  end

  def android
  end
end
