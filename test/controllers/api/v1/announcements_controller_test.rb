require 'test_helper'
require 'ultimate_test_helper'

class AnnouncementsControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::AnnouncementsController.new
    @attributes = [:id, :title, :announcement_description, :institution_id, :user_id, :department_id, :club_id, :circle_id, :public, :image_url, :comment_count, :deleted, :format, :authentication]
    @params_index = { format: :json, authentication: session_create }
    @params_show = { id: 11, title: 'Announcement', public: true, format: :json, authentication: session_create }
    @params_create = { title: 'Announcement', institution_id: 3, user_id: 3, public: true }
    @params_update = { title: 'Update Announcement' }
    @model_type = :announcement
    @model = Announcement
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
    end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
