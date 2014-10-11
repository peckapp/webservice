require 'test_helper'
require 'ultimate_test_helper'

class PecksControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::PecksController.new
    @attributes = [:id, :institution_id, :user_id, :notification_type, :message, :invited_by, :send_push_notification, :format, :authentication]
    @params_index = { format: :json, authentication: session_create }
    @params_show = { id: 12, institution_id: 3, notification_type: 'bob', format: :json, authentication: session_create }
    @params_create = { invited_by: 1, invitation: 2, user_id: 1, institution_id: 3, notification_type: 'circle_comment', message: 'hello' }
    # @params_update = { user_id: 5 }
    @model_type = :peck
    @model = Peck
    @class = PecksControllerTest
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test 'Peck destruction properly destroys its associated unaccepted circle member' do

    the_user = super_create_user
    auth_params = session_create
    auth_params[:authentication_token] = the_user.authentication_token

    c = CircleMember.take
    p = Peck.take

    # creates the proper relationship between the peck and the circle_member
    c.update_attribute(:accepted, false)
    p.update_attribute(:notification_type, 'circle_invite')
    p.update_attribute(:refers_to, c.id)

    @controller = Api::V1::PecksController.new

    delete :destroy, format: :json, id: p.id, authentication: auth_params
    assert_response :success

    assert !CircleMember.exists?(c), 'peck should have been destroyed'
  end

  test 'Peck destruction does not destroy its associated accepted circle member' do

    the_user = super_create_user
    auth_params = session_create
    auth_params[:authentication_token] = the_user.authentication_token

    c = CircleMember.take
    p = Peck.take

    # creates the proper relationship between the peck and the circle_member
    c.update_attribute(:accepted, true)
    p.update_attribute(:notification_type, 'circle_invite')
    p.update_attribute(:refers_to, c.id)

    @controller = Api::V1::PecksController.new

    delete :destroy, format: :json, id: p.id, authentication: auth_params
    assert_response :success

    assert CircleMember.exists?(c), 'peck should not have been destroyed'
  end
end
