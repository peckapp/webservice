require 'test_helper'
require 'ultimate_test_helper'

class DiningPlacesControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::DiningPlacesController.new
    @attributes = [:id, :institution_id, :name, :details_link, :gps_longitude, :gps_latitude, :range, :format, :authentication]
    @params_index = { format: :json, authentication: session_create }
    @params_show = { id: 11, institution_id: 1, name: 'Driscoll', format: :json, authentication: session_create }
    @params_create = { institution_id: 1, name: 'Paresky' }
    @params_update = { name: 'Mission' }
    @model_type = :dining_place
    @model = DiningPlace
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
