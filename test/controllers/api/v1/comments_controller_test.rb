require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::CommentsController.new
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
  end

  test "should get show" do
    get :show, :format => :json, :id => 1
    assert_response :success
  end

  test "should post create" do
    params = {institution: 1, bob: "bob", user_id: 1}
    post :create, comment: params, :format => :json
    assert_response :success
  end

  test "should patch update" do
    params = {user_id: 5}
    patch :update, :id => 1, comment: params, :format => :json
    assert_response(:success)
  end

  test "should delete" do
    delete :destroy, :format => :json, :id => 1
    assert_response :success
  end
end
