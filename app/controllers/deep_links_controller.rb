class DeepLinksController < ApplicationController
  before_action :confirm_minimal_access, except: [:native_peck, :apple, :android]

  def native_peck
    if apple_request?
      redirect_to apple_deep_links_url
    elsif android_request?
      redirect_to android_deep_links_url
    else
      @simple_event = SimpleEvent.find(params[:event_id])
    end
  end

  def apple
  end

  def android
  end
end
