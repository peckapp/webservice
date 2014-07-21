require 'test_helper'
require 'ultimate_test_helper'

class CircleMembersControllerTest < UltimateTestHelper
  def setup
    @controller = Api::V1::CircleMembersController.new
    @attributes = [:id, :institution_id, :circle_id, :user_id, :invited_by, :format, :authentication]
    @params_index = {:format => :json, :authentication => session_create}
    @params_show = {:id => 11, :institution_id => 1, :circle_id => 1, :user_id => 1, :format => :json, :authentication => session_create}
    @params_create = {:institution_id => 3, :circle_id => 20, :user_id => 5, :invited_by => 10, :authentication => session_create}
    @params_update = {:circle_id => 21, :authentication => session_create}
    @model_type = :circle_member
    @id = 12
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
