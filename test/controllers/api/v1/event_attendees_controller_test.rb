require 'test_helper'
require 'ultimate_test_helper'

class EventAttendeesControllerTest < UltimateTestHelper
  def setup
    @controller = Api::V1::EventAttendeesController.new
    @attributes = [:id, :user_id, :added_by, :category, :event_attended, :institution_id, :format, :authentication]
    @params_index = {:format => :json, :authentication => session_create}
    @params_show = {:id => 11, :user_id => 1, :category => "simple", :format => :json, :authentication => session_create}
    @params_create = {:institution_id => 1, :user_id => 2, :added_by => 3, :category => "athletic", :event_attended => 2, :authentication => session_create}
    @params_update = {:category => "simple", :authentication => session_create}
    @model_type = :event_attendee
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
