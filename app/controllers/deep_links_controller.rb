class DeepLinksController < ApplicationController
  before_action :confirm_minimal_access, except: [:native_peck, :desktop_event]

  def native_peck
    redirect_to desktop_event_deep_links_url unless mobile_request?
  end

  def desktop_event
    @simple_event = SimpleEvent.find(61)
    @institution = Institution.find(@simple_event.institution_id)
  end
end
