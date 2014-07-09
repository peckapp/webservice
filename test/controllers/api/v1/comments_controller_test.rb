require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::CommentsController.new
    @attributes = [:id, :category, :comment_from, :user_id, :content, :institution_id, :format]
    @params_show = {:id => 11, :category => "athletic", :comment_from => 2, :format => :json}
    @params_create = {:category => "simple", :comment_from => 1, :user_id => 1, :content => "fun fun fun fun fun fun", :institution_id => 71}
    @params_update = {:category => "athletic"}
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
  #   post_create(@params_create, @controller, :comment)
  # end
  #
  # test "should patch update" do
  #   patch_update(@params_update, @controller, 20, :comment)
  # end
  #
  # test "should delete destroy" do
  #   delete_destroy(@controller, 21)
  # end
end
