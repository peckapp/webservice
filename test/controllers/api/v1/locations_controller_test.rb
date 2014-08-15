require 'test_helper'
require 'ultimate_test_helper'

class LocationsControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::LocationsController.new
    @attributes = [:id, :institution_id, :name, :gps_longitude, :gps_latitude, :range, :format, :authentication]
    @params_index = { format: :json, authentication: session_create }
    @params_show = { id: 1, name: 'Bronfman', format: :json, authentication: session_create }
    @params_create = { institution_id: 1, name: 'Paresky' }
    @params_update = { name: 'Mission' }
    @model_type = :location
    @model = Location
    @id = 2
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
