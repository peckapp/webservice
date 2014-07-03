require 'test_helper'

class MenuItemsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::MenuItemsController.new
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
    params = {institution: 1, bob: "bob", institution_id: 1}
    post :create, menu_item: params, :format => :json
    assert_response :success
  end

  test "should patch update" do
    params = {institution_id: 5}
    patch :update, :id => 1, menu_item: params, :format => :json
    assert_response(:success)
  end

  test "should delete" do
    delete :destroy, :format => :json, :id => 1
    assert_response :success
  end
end
