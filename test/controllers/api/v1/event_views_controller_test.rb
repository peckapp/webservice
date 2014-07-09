require 'test_helper'

class EventViewsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::EventViewsController.new
    @attributes = [:user_id, :category, :event_viewed, :date_viewed, :institution_id]
    @params_show = {}
    @params_create = {user_id: 2, category: "simple_events", event_viewed: 5}
    @params_update = {event_viewed: 10}
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "should get index" do
    get_index(@controller)
  end

  test "should get show" do
    get_show(@params_show, @controller, @attributes, 10)
  end

  test "should post create" do
    post_create(@params_create, @controller, :event_view)
  end

  test "should patch update" do
    patch_update(@params_update, @controller, 6, :event_view)
  end

  test "should delete destroy" do
    delete_destroy(@controller, 15)
  end
end
