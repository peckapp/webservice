class DeepLinksController < ApplicationController
  before_action :confirm_minimal_access, except: [:native_peck, :apple, :android]

  def native_peck
    if apple_request?
      redirect_to apple_deep_links_url(event: params[:event_id])
    elsif android_request?
      redirect_to android_deep_links_url(event: params[:event_id] )
    else
      @simple_event = SimpleEvent.find(params[:event_id])
    end
  end

  def apple
    @event_id = params[:event]
  end

  def android
    @event_id = params[:event]
  end
end
