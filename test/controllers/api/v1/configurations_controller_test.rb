require 'test_helper'
require 'ultimate_test_helper'

class ConfigurationsControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::ConfigurationsController.new
    @attributes = [:id, :config_file_name, :mascot, :format, :authentication]
    @params_index = {:format => :json, :authentication => session_create}
    @params_show = {:id => 1, :mascot => "Red Pig", :format => :json, :authentication => session_create}
    @params_create = {:config_file_name => "configurations/happiness"}
    @params_update = {:mascot => "Purple Cow"}
    @model_type = :configuration
    @id = 2
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
