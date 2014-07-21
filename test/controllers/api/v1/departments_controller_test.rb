require 'test_helper'
require 'ultimate_test_helper'

class DepartmentsControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::DepartmentsController.new
    @attributes = [:id, :name, :institution_id, :format, :authentication]
    @params_index = {:format => :json, :authentication => session_create}
    @params_show = {:id => 3, :name => "Math", :format => :json, :authentication => session_create}
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
