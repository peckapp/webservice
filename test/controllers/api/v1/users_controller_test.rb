require 'test_helper'

class UsersControllerTest < ActionController::TestCase


  def setup
    @controller = Api::V1::UsersController.new
    @attributes = [:id, :institution_id, :first_name, :last_name, :username, :blurb, :facebook_link, :active, :format]
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
    params = {:id => 10, :institution_id => 1, :first_name => "Bob", :last_name => "Ricky", :format => :json}
    params.keys.each do |attribute|
      unless @attributes.include? attribute
        assert(false, "Attribute not found in database table.")
      end
    end
    get :show, params
    assert_response :success
  end

  test "should post create" do
    params = {institution: 1, bob: "bob", institution_id: 1}
    post :create, user: params, :format => :json
    assert_response :success
  end

  test "should patch update" do
    params = {institution_id: 5}
    patch :update, :id => 11, user: params, :format => :json
    assert_response(:success)
  end

  test "should delete" do
    delete :destroy, :format => :json, :id => 24
    assert_response :success
  end
end
