require 'test_helper'
# require 'ultimate_test_helper'

class EventViewsControllerTest < ActiveSupport::TestCase

  def setup
    @controller = Api::V1::EventViewsController.new
    @attributes = [:user_id, :category, :event_viewed, :date_viewed, :institution_id, :format]
    @params_show = {:id => 1, :user_id => 2, :institution_id => 3, :format => :json}
    @params_create = {institution_id: 11, user_id: 2, category: "simple_events", event_viewed: 5}
    @params_update = {event_viewed: 10}
    @model_type = :event_view
    @id = 15
  end
end
