require 'test_helper'

class AthleticTeamsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::AthleticTeamsController.new
    @attributes = [:id, :institution_id, :sport_name, :gender, :head_coach, :team_link, :format]
    @params_show = {:id => 12, :institution_id => 1, :gender => "female", :format => :json}
    @params_create = {:institution_id => 2, :sport_name => "swimming", :gender => "male"}
    @params_update = {:sport_name => "rugby"}
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
    post_create(@params_create, @controller, :athletic_team)
  end

  test "should patch update" do
    patch_update(@params_update, @controller, 20, :athletic_team)
  end

  test "should delete destroy" do
    delete_destroy(@controller, 21)
  end
end
