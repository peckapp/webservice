require 'test_helper'

class AthleticEventsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::AthleticEventsController.new
    @attributes = [:id, :institution_id, :athletic_team_id, :opponent, :team_score, :opponent_score, :home_or_away,:location, :result, :note, :date_and_time, :format]
    @params_show = {:id => 1, :institution_id => 1, :athletic_team_id => 1, :format => :json}
    @params_create = {:institution_id => 3, :athletic_team_id => 1, :location => "Cole Field"}
    @params_update = {:location => "Bronfman"}
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
    post_create(@params_create, @controller, :athletic_event)
  end

  test "should patch update" do
    patch_update(@params_update, @controller, 20, :athletic_event)
  end

  test "should delete destroy" do
    delete_destroy(@controller, 21)
  end
end
