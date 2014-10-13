require 'test_helper'
require 'ultimate_test_helper'

class AthleticEventsControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::AthleticEventsController.new
    @attributes = [:id, :institution_id, :athletic_team_id, :opponent, :team_score, :opponent_score, :home_or_away, :location, :result, :note, :start_date, :format, :authentication]
    @params_index = { format: :json, authentication: session_create }
    @params_show = { id: 1, institution_id: 1, athletic_team_id: 1, format: :json, authentication: session_create }
    @params_create = { institution_id: 3, athletic_team_id: 1, location: 'Cole Field' }
    @params_update = { location: 'Bronfman' }
    @model_type = :athletic_event
    @model = AthleticEvent
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
