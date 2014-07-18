require 'test_helper'
require 'ultimate_test_helper'

class DiningPeriodsControllerTest < UltimateTestHelper
  def setup
    @controller = Api::V1::DiningPeriodsController.new
    @attributes = [:id, :start_time, :end_time, :day_of_week, :dining_opportunity_id, :dining_place_id, :institution_id, :format, :authentication]
    @params_index = {:format => :json, :authentication => session_create}
    @params_show = {:id => 2, :dining_place_id => 1, :format => :json, :authentication => session_create}
    @params_create = {:institution_id => 1, :dining_place_id => 2, :dining_opportunity_id => 3, :start_time => Time.now, :end_time => Time.now}
    @params_update = {:institution_id => 2}
    @model_type = :dining_period
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
