require 'test_helper'
require 'ultimate_test_helper'

class UniqueDeviceIdentifiersControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::UniqueDeviceIdentifiersController.new
    @attributes = [:token, :format, :id, :authentication]
    @params_index = { format: :json, authentication: session_create }
    @params_show = { id: 8, format: :json, authentication: session_create }
    @params_create = { token: SecureRandom.hex(40) }
    @params_update = { udid: UniqueDeviceIdentifier.take.udid, token: SecureRandom.hex(30) }
    @model_type = :unique_device_identifier
    @model = UniqueDeviceIdentifier
    @id = 5
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test 'sucessful call to update token for udid controller' do
    the_user = super_create_user
    auth_params = session_create
    auth_params[:authentication_token] = the_user.authentication_token

    @controller = @the_controller

    patch :update_token, id: @id, unique_device_identifier: @params_update, authentication: auth_params, format: :json
    assert_response :success
  end

  test 'properly updated token for udid' do
    the_user = super_create_user
    auth_params = session_create
    auth_params[:authentication_token] = the_user.authentication_token

    @controller = @the_controller

    params = { udid: UniqueDeviceIdentifier.take.udid, token: SecureRandom.hex(40) }

    patch :update_token, id: @id, unique_device_identifier: params, authentication: auth_params, format: :json
    assert_response :success
  end

  test 'properly updated udid for token' do
    the_user = super_create_user
    auth_params = session_create
    auth_params[:authentication_token] = the_user.authentication_token

    @controller = @the_controller

    params = { udid: SecureRandom.hex(30), token: UniqueDeviceIdentifier.take.token }

    patch :update_token, id: @id, unique_device_identifier: params, authentication: auth_params, format: :json
    assert_response :success
  end
end
