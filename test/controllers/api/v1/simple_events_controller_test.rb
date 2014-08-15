require 'test_helper'
require 'ultimate_test_helper'

class SimpleEventsControllerControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::SimpleEventsController.new
    @attributes = [:id, :title, :event_description, :institution_id, :user_id, :category, :organizer_id, :event_url, :public, :image_url, :comment_count, :start_date, :end_date, :deleted, :latitude, :longitude, :format, :authentication]
    @params_index = { user_id: 1, format: :json, authentication: session_create }
    @params_show = { id: 11, title: 'Summer Observatory', public: true, format: :json, authentication: session_create }
    @params_create = { title: 'Super Dope Event', institution_id: 3, user_id: 3, public: true, start_date: DateTime.current, end_date: DateTime.current + 1.hour }
    @params_check = { start_date: DateTime.current, end_date: DateTime.current + 3.hour, format: :json, authentication: session_create }
    @params_update = { title: 'updated event title' }
    @model_type = :simple_event
    @model = SimpleEvent
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test 'should check dates' do
    @controller = @the_controller
    get :check_time_conflicts, @params_check
    assert_response :success
  end
end
