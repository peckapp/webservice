require 'test_helper'

class NotificationViewsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::NotificationViewsController.new
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
