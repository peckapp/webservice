require 'test_helper'

class PushNotificationsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::PushNotificationsController.new
    @attributes = [:id, :user_id, :type, :response, :format]
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
  end

  test "should get show" do
    params = {:id => 10, :institution_id => 2, :open => true, :format => :json}
    params.keys.each do |attribute|
      unless @attributes.include? attribute
        assert(false, "Attribute not found in database table.")
      end
    end
    get :show, params
    assert_response :success
  end

  test "should post create" do
    params = {institution: 1, bob: "bob", user_id: 1}
    post :create, push_notification: params, :format => :json
    assert_response :success
  end

  test "should patch update" do
    params = {user_id: 5}
    patch :update, :id => 1, push_notification: params, :format => :json
    assert_response(:success)
  end

  test "should delete" do
    delete :destroy, :format => :json, :id => 1
    assert_response :success
  end
end
