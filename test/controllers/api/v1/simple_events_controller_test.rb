require 'test_helper'

class SimpleEventsControllerControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::SimpleEventsController.new
    @attributes = [:id, :title, :event_description, :institution_id, :user_id, :department_id, :club_id, :circle_id, :event_url, :open, :image_url, :comment_count, :start_date, :end_date, :deleted, :latitude, :longitude, :format]
    @params_show = {:id => 20, :title => "Summer Observatory", :open => true}
    @params_create = {:title => "Super Dope Event", :institution_id => 3, :user_id => 3, :open => true, :start_date => 2007-12-04 00:00:00, :end_date => 2007-12-04 00:00:00, :format => :json}
    @params_update = {:title => "Less Dope Event"}
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "should get index" do
    get_index(@controller)
  end

  test "should get show" do
    get_show(@params_show, @controller, @attributes)
  end

  test "should post create" do
    post_create(@params_create, @controller)
  end

  test "should patch update" do
    patch_update(@params_update, @controller, 20)
  end

  test "should delete destroy" do
    delete_destroy(@controller, 21)
  end
end
