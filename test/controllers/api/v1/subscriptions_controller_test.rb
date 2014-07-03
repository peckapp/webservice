require 'test_helper'

class SubscriptionsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::SubscriptionsController.new
    @attributes = [:id, :user_id, :category, :subscribed_to, :format]
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
    params = {:id => 10, :user_id => 1, :category => "bros", :subscribed_to => 2, :format => :json}
    params.keys.each do |attribute|
      unless @attributes.include? attribute
        assert(false, "Attribute not found in database table.")
      end
    end
    get :show, params
    assert_response :success
  end

  test "should post create" do
    params = {:category => "idk", :user_id => 1, :subscribed_to => 8}
    post :create, subscription: params, :format => :json
    assert_response :success
  end

  test "should patch update" do
    params = {user_id: 2}
    patch :update, :id => 15, subscription: params, :format => :json
    assert_response(:success)
  end

  test "should delete" do
    delete :destroy, :format => :json, :id => 16
    assert_response :success
  end
end
