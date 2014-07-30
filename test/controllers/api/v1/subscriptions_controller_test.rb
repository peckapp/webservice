require 'test_helper'
require 'ultimate_test_helper'

class SubscriptionsControllerTest < UltimateTestHelper
  def setup
    @class = SubscriptionsControllerTest
    @the_controller = Api::V1::SubscriptionsController.new
    @attributes = [:id, :user_id, :category, :subscribed_to, :format, :authentication]
    @params_show = {:id => 11, :user_id => 1, :category => "math", :format => :json, :authentication => session_create}
    @params_index = {:format => :json, :authentication => session_create}
    @params_create = [{:institution_id => 1, :user_id => 5, :category => "physics", :subscribed_to => 3}]
    @params_multiple_create = [{:institution_id => 2, :user_id => 10, :category => "chemistry", :subscribed_to => 5},{:institution_id => 1, :user_id => 5, :category => "computer science", :subscribed_to => 10}]
    @params_update = {:category => "statistics"}
    @params_delete = {:subscriptions => "[1,2,3,4]"}
    @model_type = :subscription
    @model = Subscription
    @id = 2
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "should create a bunch of subscriptions" do

    the_user = super_create_user

    auth_params = session_create
    auth_params[:authentication_token] = the_user.authentication_token

    @controller = @the_controller
    post :create, {:subscriptions => @params_multiple_create, :authentication => auth_params, :format => :json}
    assert_response :success
    assigns(:subscriptions).each do |sub|
      assert_not_nil sub
    end

  end
end
