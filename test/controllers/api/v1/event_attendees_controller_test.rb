require 'test_helper'

class EventAttendeesControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::EventAttendeesController.new
    @attributes = [:id, :user_id, :added_by, :category, :event_attended, :institution_id, :format]
    @params_show = {:id => 11, :user_id => 1, :category => "simple", :format => :json}
    @params_create = {:institution_id => 1, :user_id => 2, :added_by => 3, :category => "athletic", :event_attended => 2}
    @params_update = {}
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  # test "should get index" do
  #   get_index(@controller)
  # end
  #
  # test "should get show" do
  #   get_show(@params_show, @controller, @attributes)
  # end
  #
  # test "should post create" do
  #   post_create(@params_create, @controller, :event_attendee)
  # end
  #
  # test "should patch update" do
  #   patch_update(@params_update, @controller, 20, :event_attendee)
  # end
  #
  # test "should delete destroy" do
  #   delete_destroy(@controller, 21)
  # end
end
