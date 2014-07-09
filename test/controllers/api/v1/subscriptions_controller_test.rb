require 'test_helper'

class SubscriptionsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::SubscriptionsController.new
    @attributes = [:id, :user_id, :category, :subscribed_to, :format]
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
    @params_show = {:id => 11, :user_id => 1, :category => "math", :format => :json}
    @params_create = {:user_id => 5, :category => "physics"}
    @params_update = {:category => "statistics"}
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "should get index" do
    get_index(@controller)
  end

  test "should get show" do
    get_show(@params_show, @controller, @attributes)
  end

  test "should post create" do
    post_create(@params_create, @controller, :subscription)
  end

  test "should patch update" do
    patch_update(@params_update, @controller, 20, :subscription)
  end

  test "should delete destroy" do
    delete_destroy(@controller, 21)
  end
end
