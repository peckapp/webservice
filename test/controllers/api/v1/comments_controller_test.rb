require 'test_helper'
require 'ultimate_test_helper'

class CommentsControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::CommentsController.new
    @attributes = [:id, :category, :comment_from, :user_id, :content, :institution_id, :format, :authentication]
    @params_index = {:format => :json, :authentication => session_create}
    @params_show = {:id => 11, :category => "athletic", :comment_from => 2, :format => :json, :authentication => session_create}
    @params_create = {:category => "circle", :comment_from => 1, :user_id => 1, :content => "fun fun fun fun fun fun", :institution_id => 71, :message => "hello", :send_push_notification => false}
    @params_update = {:category => "athletic"}
    @model_type = :comment
    @model = Comment
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
