require 'test_helper'
require 'ultimate_test_helper'

class DiningPlacesControllerTest < UltimateTestHelper
  def setup
    @controller = Api::V1::DiningPlacesController.new
    @attributes = [:id, :institution_id, :name, :details_link, :gps_longitude, :gps_latitude, :range, :format]
    @params_index = {:format => :json}
    @params_show = {:id => 11, :institution_id => 1, :name => "Driscoll", :format => :json}
    @params_create = {:institution_id => 1, :name => "Paresky"}
    @params_update = {:name => "Mission"}
    @model_type = :dining_place
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
