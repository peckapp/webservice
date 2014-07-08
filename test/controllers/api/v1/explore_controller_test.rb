require 'test_helper'

class ExploreControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::ExploreController.new
  end

  def teardown
  end

  test "should get index" do
    get_index(@controller)
  end
end
