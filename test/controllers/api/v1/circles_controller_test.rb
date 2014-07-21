require 'test_helper'
require 'ultimate_test_helper'

class CirclesControllerTest < UltimateTestHelper
  def setup
    @controller = Api::V1::CirclesController.new
    @attributes = [:id, :institution_id, :user_id, :circle_name, :format, :authentication]
    @params_index = {:format => :json, :authentication => session_create}
    @params_show = {:id => 11, :institution_id => 1, :user_id => 1, :circle_name => "Bob", :format => :json, :authentication => session_create}
    @params_create = {:institution_id => 3, :user_id => 59, :circle_name => "CIRCLE", :authentication => session_create}
    @params_update = {:circle_name => "HIIII", :authentication => session_create}
    @model_type = :circle
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
