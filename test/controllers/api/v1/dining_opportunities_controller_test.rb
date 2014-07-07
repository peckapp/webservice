require 'test_helper'

class DiningOpportunitiesControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::DiningOpportunitiesController.new
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
