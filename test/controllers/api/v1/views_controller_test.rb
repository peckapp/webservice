require 'test_helper'
require 'ultimate_test_helper'

class ViewsControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::ViewsController.new
    @attributes = [:id, :user_id, :category, :content_id, :date_viewed, :institution_id, :format, :authentication]
    @params_index = { format: :json, authentication: session_create }
    @params_show = { id: 1, user_id: 2, institution_id: 3, format: :json, authentication: session_create }
    @params_create = { institution_id: 11, user_id: 2, category: 'simple', content_id: 5 }
    @params_update = { content_id: 10 }
    @model_type = :view
    @model = View
    @id = 15
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
