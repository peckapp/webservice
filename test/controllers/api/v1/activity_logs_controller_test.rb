require 'test_helper'

class ActivityLogsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::ActivityLogsController.new
    @attributes = [:id, :institution_id, :sender, :receiver, :category, :from_event, :circle_id, :type_of_activity, :message, :read_status, :format]
    @params_show = {:id => 11, :institution_id => 1, :sender => 12, :format => :json}
    @params_create = {:institution_id => 3, :sender => 15, :receiver => 2, :category => "idk", :type_of_activity => "athletic", :message => "FUN FUN FUN", :read_status => false}
    @params_update = {:message => "HEYYYYYYYYYYYYYYY"}
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
    post_create(@params_create, @controller, :activity_log)
  end

  test "should patch update" do
    patch_update(@params_update, @controller, 20, :activity_log)
  end

  test "should delete destroy" do
    delete_destroy(@controller, 21)
  end
end
