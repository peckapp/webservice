require 'test_helper'

class ConfigurationsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::ConfigurationsController.new
    @attributes = [:id, :config_file_name, :mascot, :institution_id, :format]
    @params_show = {:id => 1, :mascot => "Red Pig", :format => :json}
    @params_create = {:institution_id => 1, :config_file_name => "configurations/happiness"}
    @params_update = {:mascot => "Purple Cow"}
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  # test "should get index" do
  #   get_index(@controller)
  # end
  #
  # test "should get show" do
  #   get_show(@params_show, @controller, @attributes)
  # end
  #
  # test "should post create" do
  #   post_create(@params_create, @controller, :configuration)
  # end
  #
  # test "should patch update" do
  #   patch_update(@params_update, @controller, 2, :configuration)
  # end
  #
  # test "should delete destroy" do
  #   delete_destroy(@controller, 3)
  # end
end
