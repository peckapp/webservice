require 'test_helper'

class UserDeviceTokensControllerTest < ActionController::TestCase

  def setup
    @controller = Api::V1::UserDeviceTokensController.new
    @attributes = [:token, :institution_id, :format, :id]
    @params_show = {:id => 11, :institution_id => 5, :token => "blob", :format => :json}
    @params_create = {:institution_id => 2, :token => "dope_token"}
    @params_update = {:token => "jill"}
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
    post_create(@params_create, @controller, :user_device_token)
  end

  test "should patch update" do
    patch_update(@params_update, @controller, 20, :user_device_token)
  end

  test "should delete destroy" do
    delete_destroy(@controller, 21)
  end
end
