require 'test_helper'

class SimpleEventsControllerControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::SimpleEventsController.new
    @attributes = [:id, :title, :event_description, :institution_id, :user_id, :department_id, :club_id, :circle_id, :event_url, :open, :image_url, :comment_count, :start_date, :end_date, :deleted, :latitude, :longitude, :format]
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    #   assert_not_nil assigns(:simple_events) or assert_not_nil assigns(@simple_events)
  end

  test "should get show" do
    params = {:id => 10, :institution_id => 2, :open => true, :format => :json}
    params.keys.each do |attribute|
      unless @attributes.include? attribute
        assert(false, "Attribute not found in database table.")
      end
    end
    get :show, params
    assert_response :success
  #   assert_not_nil assigns(:simple_event)
  end

  test "should post create" do
    params = {institution: 1, bob: "bob", institution_id: 1}
    post :create, simple_event: params, :format => :json
    assert_response :success
    #   assert_not_nil assigns(:simple_event)
  end

  test "should patch update" do
    params = {institution_id: 5}
    patch :update, :id => 10, simple_event: params, :format => :json
    assert_response(:success)
    # assert_not_nil assigns(:simple_event)
  end

  test "should delete" do
    delete :destroy, :format => :json, :id => 10
    assert_response :success
    #   assert_not_nil assigns(:simple_event)
  end
end
