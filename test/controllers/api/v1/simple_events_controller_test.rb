require 'test_helper'
require 'ultimate_test_helper'

class SimpleEventsControllerControllerTest < UltimateTestHelper
  def setup
    @controller = Api::V1::SimpleEventsController.new
    @attributes = [:id, :title, :event_description, :institution_id, :user_id, :department_id, :club_id, :circle_id, :event_url, :open, :image_url, :comment_count, :start_date, :end_date, :deleted, :latitude, :longitude, :format]
    @params_index = {:format => :json}
    @params_show = {:id => 11, :title => "Summer Observatory", :open => true, :format => :json}
    @params_create = {:title => "Super Dope Event", :institution_id => 3, :user_id => 3, :open => true, :start_date => DateTime.current, :end_date => DateTime.current + 1.hour}
    @params_update = {:title => "updated event title"}
    @model_type = :simple_event
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
