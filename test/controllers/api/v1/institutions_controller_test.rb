require 'test_helper'
require 'ultimate_test_helper'

class InstitutionsControllerTest < UltimateTestHelper
  def setup
    @controller = Api::V1::InstitutionsController.new
    @attributes = [:id, :name, :street_address, :city, :state, :country, :gps_longitude, :gps_latitude, :range, :configuration_id, :api_key, :format]
    @params_index = {:format => :json}
    @params_show = {:id => 1, :configuration_id => 1, :format => :json}
    @params_create = {:name => "Some Institution", :street_address => "institution_street", :city => "Boston", :state => "MA", :country => "USA", gps_longitude: (rand * 100.0), gps_latitude: (rand * 100.0), range: (rand * 0.01), :configuration_id => 21, :api_key => SecureRandom.hex(8)}
    @params_update = {:name => "Sample Institution"}
    @model_type = :institution
    @id = 1
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
