require 'test_helper'
require 'ultimate_test_helper'

class UserDeviceTokensControllerTest < UltimateTestHelper

  def setup
    @the_controller = Api::V1::UserDeviceTokensController.new
    @attributes = [:token, :format, :id, :authentication]
    @params_index = {:format => :json, :authentication => session_create}
    @params_show = {:id => 8, :format => :json, :authentication => session_create}
    @params_create = {:token => "dope_token"}
    @params_update = {:token => "jill"}
    @model_type = :user_device_token
    @model = UserDeviceToken
    @id = 5
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
