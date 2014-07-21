require 'test_helper'
require 'ultimate_test_helper'

class ActivityLogsControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::ActivityLogsController.new
    @attributes = [:id, :institution_id, :sender, :receiver, :category, :from_event, :circle_id, :type_of_activity, :message, :read_status, :format, :authentication]
    @params_index = {:format => :json, :authentication => session_create}
    @params_show = {:id => 5, :format => :json, :authentication => session_create}
    @params_create = {:institution_id => 3, :sender => 15, :receiver => 2, :category => "idk", :type_of_activity => "athletic", :message => "FUN FUN FUN", :read_status => false}
    @params_update = {:message => "HEYYYYYYYYYYYYYYY"}
    @model_type = :activity_log
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
