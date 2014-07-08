require 'test_helper'

class ClubsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::ClubsController.new
    @attributes = [:id, :institution_id, :club_name, :description, :user_id, :format]
    @params_show = {:id => 12, :institution_id => 1, :format => :json}
    @params_create = {:institution_id => 1, :club_name => "The Club!"}
    @params_update = {:club_name => "Harry Potter fan club"}
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
    post_create(@params_create, @controller, :club)
  end

  test "should patch update" do
    patch_update(@params_update, @controller, 20, :club)
  end

  test "should delete destroy" do
    delete_destroy(@controller, 21)
  end
end
