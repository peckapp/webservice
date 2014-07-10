require 'test_helper'

class ExploreControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::ExploreController.new
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success, "Index action not successful"
  end
end
