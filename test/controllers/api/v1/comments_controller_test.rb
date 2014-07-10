require 'test_helper'
require 'ultimate_test_helper'

class CommentsControllerTest < UltimateTestHelper
  def setup
    @controller = Api::V1::CommentsController.new
    @attributes = [:id, :category, :comment_from, :user_id, :content, :institution_id, :format]
    @params_index = {:format => :json}
    @params_show = {:id => 11, :category => "athletic", :comment_from => 2, :format => :json}
    @params_create = {:category => "simple", :comment_from => 1, :user_id => 1, :content => "fun fun fun fun fun fun", :institution_id => 71}
    @params_update = {:category => "athletic"}
    @model_type = :comment
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
