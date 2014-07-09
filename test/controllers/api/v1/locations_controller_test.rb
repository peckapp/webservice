require 'test_helper'
require 'ultimate_test_helper'

class LocationsControllerTest < UltimateTestHelper
  def setup
    @controller = Api::V1::LocationsController.new
    @attributes = [:id, :institution_id, :name, :gps_longitude, :gps_latitude, :range, :format]
    @params_show = {:id => 1, :name => "Bronfman", :format => :json}
    @params_create = {:institution_id => 1, :name => "Paresky"}
    @params_update = {:name => "Mission"}
    @model_type = :location
    @id = 2
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
