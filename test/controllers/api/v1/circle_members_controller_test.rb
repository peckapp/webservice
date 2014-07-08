require 'test_helper'

class CircleMembersControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::CircleMembersController.new
    @attributes = [:id, :institution_id, :circle_id, :user_id, :invited_by, :format]
    @params_show = {:institution_id => 1, :circle_id => 1, :user_id => 1, :format => :json }
    @params_create = {:institution_id => 3, :circle_id => 20, :user_id => 5, :invited_by => 10}
    @params_update = {:circle_id => 21}
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "should get index" do
    get_index(@controller)
  end

  test "should get show" do
    get_show(@params_show, @controller, @attributes, 11)
  end

  test "should post create" do
    post_create(@params_create, @controller, :circle_member)
  end

  test "should patch update" do
    patch_update(@params_update, @controller, 20, :circle_member)
  end

  test "should delete destroy" do
    delete_destroy(@controller, 21)
  end
end
