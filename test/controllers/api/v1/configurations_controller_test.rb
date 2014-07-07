require 'test_helper'

class ConfigurationsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::ConfigurationsController.new
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
