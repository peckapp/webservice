require 'test_helper'
require 'ultimate_test_helper'

class CirclesControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::CirclesController.new
    @attributes = [:id, :institution_id, :user_id, :circle_name, :format, :authentication]
    @params_index = {:format => :json, :authentication => session_create}
    @params_show = {:id => 11, :institution_id => 1, :user_id => 1, :circle_name => "Bob", :format => :json, :authentication => session_create}
    @params_create = {:institution_id => 3, :user_id => 59, :circle_name => "CIRCLE", :circle_member_ids => [1,2,3,4]}
    @params_update = {:circle_name => "HIIII"}
    @model_type = :circle
    @model = Circle
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
