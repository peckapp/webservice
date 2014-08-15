require 'test_helper'
require 'ultimate_test_helper'

class InstitutionsControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::InstitutionsController.new
    @attributes = [:id, :name, :street_address, :city, :state, :country, :gps_longitude, :gps_latitude, :range, :configuration_id, :api_key, :format, :authentication]
    @params_index = { format: :json, authentication: session_create }
    @params_show = { id: 1, configuration_id: 1, format: :json, authentication: session_create }
    @params_create = { name: 'Some Institution', street_address: 'institution_street', city: 'Boston', state: 'MA', country: 'USA', gps_longitude: (rand * 100.0), gps_latitude: (rand * 100.0), range: (rand * 0.01), configuration_id: 21, api_key: SecureRandom.hex(8) }
    @params_update = { name: 'Sample Institution' }
    @model_type = :institution
    @model = Institution
    @id = 1
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
