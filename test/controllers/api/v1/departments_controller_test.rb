require 'test_helper'

class DepartmentsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::DepartmentsController.new
    @attributes = [:id, :name, :institution_id, :format]
    @params_show = {:id => 3, :name => "Math", :format => :json}
    @params_create = {:name => "Stats", :institution_id => 1}
    @params_update = {:name => "Physics"}
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
  #   post_create(@params_create, @controller, :department)
  # end
  #
  # test "should patch update" do
  #   patch_update(@params_update, @controller, 1, :department)
  # end
  #
  # test "should delete destroy" do
  #   delete_destroy(@controller, 2)
  # end
end
