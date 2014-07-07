require 'test_helper'

class MenuItemsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::MenuItemsController.new
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
