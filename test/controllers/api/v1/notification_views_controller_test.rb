require 'test_helper'
require 'ultimate_test_helper'

class NotificationViewsControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::NotificationViewsController.new
    @attributes = [:id, :user_id, :activity_log_id, :date_viewed, :viewed, :institution_id, :format, :authentication]
    @params_index = {:format => :json, :authentication => session_create}
    @params_show = {:id => 12, :user_id => 1, :format => :json, :authentication => session_create}
    @params_create = {:user_id => 2, :activity_log_id => 3, :viewed => false, :institution_id => 1}
    @params_update = {:viewed => true}
    @model_type = :notification_view
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
