require 'test_helper'

class DiningPeriodsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::DiningPeriodsController.new
    @attributes = [:id, :start_time, :end_time, :day_of_week, :dining_opportunity_id, :dining_place_id, :institution_id, :format]
    @params_show = {:id => 2, :dining_place_id => 1, :format => :json}
    @params_create = {:institution_id => 1, :dining_place_id => 2, :dining_opportunity_id => 3, :start_time => Time.now, :end_time => Time.now}
    @params_update = {:institution_id => 2}
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
  #   post_create(@params_create, @controller, :dining_period)
  # end
  #
  # test "should patch update" do
  #   patch_update(@params_update, @controller, 20, :dining_period)
  # end
  #
  # test "should delete destroy" do
  #   delete_destroy(@controller, 21)
  # end
end
