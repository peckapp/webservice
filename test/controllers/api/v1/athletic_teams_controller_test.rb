require 'test_helper'
require 'ultimate_test_helper'

class AthleticTeamsControllerTest < UltimateTestHelper
  def setup
    @controller = Api::V1::AthleticTeamsController.new
    @attributes = [:id, :institution_id, :sport_name, :gender, :head_coach, :team_link, :format]
    @params_show = {:id => 12, :institution_id => 1, :gender => "female", :format => :json}
    @params_create = {:institution_id => 2, :sport_name => "swimming", :gender => "male"}
    @params_update = {:sport_name => "rugby"}
    @model_type = :athletic_team
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
