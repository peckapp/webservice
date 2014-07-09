require 'test_helper'

class CirclesControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::CirclesController.new
    @attributes = [:id, :institution_id, :user_id, :circle_name, :format]
    @params_show = {:id => 11, :institution_id => 1, :user_id => 1, :circle_name => "Bob", :format => :json}
    @params_create = {:institution_id => 3, :user_id => 59, :circle_name => "CIRCLE"}
    @params_update = {:circle_name => "HIIII"}
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  # test "should get index" do
  #   get_index(@controller)
  # end
  #
  # test "should get show" do
  #   get_show(@params_show, @controller, @attributes)
  # end
  #
  # test "should post create" do
  #   post_create(@params_create, @controller, :circle)
  # end
  #
  # test "should patch update" do
  #   patch_update(@params_update, @controller, 20, :circle)
  # end
  #
  # test "should delete destroy" do
  #   delete_destroy(@controller, 21)
  # end
end
