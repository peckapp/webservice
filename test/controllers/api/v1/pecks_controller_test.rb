require 'test_helper'
require 'ultimate_test_helper'

class PecksControllerTest < UltimateTestHelper

  def setup
    @the_controller = Api::V1::PecksController.new
    @attributes = [:id, :institution_id, :user_id, :notification_type, :message, :invited_by, :send_push_notification, :format, :authentication]
    @params_index = {:format => :json, :authentication => session_create}
    @params_show = {:id => 12, :institution_id => 3, :notification_type => "bob", :format => :json, :authentication => session_create}
    @params_create = {:institution_id => 1, user_id: 1, :notification_type => "james", :message => "John invited you to the event 'Hello World' ", :send_push_notification => true}
    @params_update = {:user_id => 5}
    @model_type = :peck
    @model = Peck
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end