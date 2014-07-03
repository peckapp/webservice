require 'test_helper'

class UserDeviceTokensControllerTest < ActionController::TestCase

  def setup
    @controller = Api::V1::UserDeviceTokensController.new
    @attributes = [:token, :format, :id]
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
    params = {:id => 10, :token => "soybeans", :format => :json}
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
    post :create, user_device_token: params, :format => :json
    assert_response :success
  end

  test "should patch update" do
    params = {institution: 2, user_id: 2}
    patch :update, :id => 20, user_device_token: params, :format => :json
    assert_response(:success)
  end

  test "should delete" do
    delete :destroy, :format => :json, :id => 12
    assert_response :success
  end
end
