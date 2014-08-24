require 'test_helper'
require 'ultimate_test_helper'

class CircleMembersControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::CircleMembersController.new
    @attributes = [:id, :institution_id, :circle_id, :user_id, :invited_by, :format, :authentication]
    @params_index = { format: :json, authentication: session_create }
    @params_show = { id: 11, institution_id: 1, circle_id: 1, user_id: 1, format: :json }
    @params_create = { institution_id: 3, circle_id: 20, user_id: 5, invited_by: 10, send_push_notification: true, message: 'hello' }
    @params_update = { circle_id: 21 }
    @params_delete = { user_id: 1, circle_id: 1 }
    @model_type = :circle_member
    @model = CircleMember
    @id = 12
    @class = CircleMembersControllerTest
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test 'circle members shouldnt be able to be created twice' do
    the_user = super_create_user

    auth_params = session_create
    auth_params[:authentication_token] = the_user.authentication_token

    @controller = Api::V1::CircleMembersController.new

    params = { institution_id: 3, circle_id: 21, user_id: 5, invited_by: 10, send_push_notification: true, message: 'hello' }

    # post a new circle member
    post :create, circle_member: params, authentication: auth_params, format: :json
    assert_response :success

    # post same item again
    post :create, circle_member: params, authentication: auth_params, format: :json
    assert_response :found

  end
end
