require 'test_helper'
require 'ultimate_test_helper'

class ClubsControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::ClubsController.new
    @attributes = [:id, :institution_id, :club_name, :description, :user_id, :format, :authentication]
    @params_index = { format: :json, authentication: session_create }
    @params_show = { id: 12, institution_id: 1, format: :json, authentication: session_create }
    @params_create = { institution_id: 1, club_name: 'The Club!' }
    @params_update = { club_name: 'Harry Potter fan club' }
    @model_type = :club
    @model = Club
    @id = 15
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
