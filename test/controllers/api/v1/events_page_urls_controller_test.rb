require 'test_helper'

class EventsPageUrlsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::EventsPageUrlsController.new
    @attributes = []
    @params_show = {}
    @params_create = {}
    @params_update = {}
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
    post_create(@params_create, @controller, :event_page_url)
  end

  test "should patch update" do
    patch_update(@params_update, @controller, 20, :event_page_url)
  end

  test "should delete destroy" do
    delete_destroy(@controller, 21)
  end
end
