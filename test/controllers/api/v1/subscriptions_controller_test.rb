require 'test_helper'
require 'ultimate_test_helper'

class SubscriptionsControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::SubscriptionsController.new
    @attributes = [:id, :user_id, :category, :subscribed_to, :format, :authentication]
    @params_show = {:id => 11, :user_id => 1, :category => "math", :format => :json, :authentication => session_create}
    @params_index = {:format => :json, :authentication => session_create}
    @params_create = {:institution_id => 1, :user_id => 5, :category => "physics", :subscribed_to => 3}
    @params_update = {:category => "statistics"}
    @model_type = :subscription
    @id = 2
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
