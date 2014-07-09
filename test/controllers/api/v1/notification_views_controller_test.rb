require 'test_helper'

class NotificationViewsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::NotificationViewsController.new
    @attributes = [:id, :user_id, :activity_log_id, :date_viewed, :viewed, :institution_id, :format]
    @params_show = {:id => 12, :user_id => 1, :format => :json}
    @params_create = {:user_id => 2, :activity_log_id => 3, :viewed => false, :institution_id => 1}
    @params_update = {:viewed => true}
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
  # 
  # test "should get index" do
  #   get_index(@controller)
  # end
  #
  # test "should get show" do
  #   get_show(@params_show, @controller, @attributes)
  # end
  #
  # test "should post create" do
  #   post_create(@params_create, @controller, :notification_view)
  # end
  #
  # test "should patch update" do
  #   patch_update(@params_update, @controller, 20, :notification_view)
  # end
  #
  # test "should delete destroy" do
  #   delete_destroy(@controller, 21)
  # end
end
