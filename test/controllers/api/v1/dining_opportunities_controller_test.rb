require 'test_helper'
require 'ultimate_test_helper'

class DiningOpportunitiesControllerTest < UltimateTestHelper
  def setup
    @controller = Api::V1::DiningOpportunitiesController.new
    @attributes = [:id, :dining_opportunity_type, :institution_id, :format]
    @params_show = {:id => 11, :dining_opportunity_type => "dinner", :institution_id => 1, :format => :json}
    @params_create = {:dining_opportunity_type => "lunch", :institution_id => 2}
    @params_update = {:dining_opportunity_type => "breakfast"}
    @model_type = :dining_opportunity
    @id = 2
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
