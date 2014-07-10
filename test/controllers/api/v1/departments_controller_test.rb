require 'test_helper'
require 'ultimate_test_helper'

class DepartmentsControllerTest < UltimateTestHelper
  def setup
    @controller = Api::V1::DepartmentsController.new
    @attributes = [:id, :name, :institution_id, :format]
    @params_index = {:format => :json}
    @params_show = {:id => 3, :name => "Math", :format => :json}
    @params_create = {:name => "Stats", :institution_id => 1}
    @params_update = {:name => "Physics"}
    @model_type = :department
    @id = 1
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
