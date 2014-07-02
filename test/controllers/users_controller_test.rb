require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @controller = Api::V1::UsersController.new
  end

  test "the truth" do
    assert true
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
  end

  test "should get show" do
    get :show, :format => :json, :id => 1
    assert_response :success
  end

end
