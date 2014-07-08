require 'test_helper'

class PushNotificationsControllerTest < ActionController::TestCase

  def setup
    @controller = Api::V1::PushNotificationsController.new
    @attributes = [:id, :institution_id, :user_id, :notification_type, :response, :format]
    @params_show = {:id => 22, :institution_id => 3, :notification_type => "bob", :format => :json}
    @params_create = {:institution_id => 1, user_id: 1, :notification_type => "james"}
    @params_update = {:user_id => 5}
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
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
    post_create(@params_create, @controller)
  end

  test "should patch update" do
    patch_update(@params_update, @controller, 20)
  end

  test "should delete destroy" do
    delete_destroy(@controller, 21)
  end
end
