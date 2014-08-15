require 'test_helper'
require 'ultimate_test_helper'

class EventsPageUrlsControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::EventsPageUrlsController.new
    @attributes = [:id, :institution_id, :url, :type, :format, :authentication]
    @params_index = { format: :json, authentication: session_create }
    @params_show = { id: 8, format: :json, authentication: session_create }
    @params_create = { institution_id: 2, url: 'file/path' }
    @params_update = { url: 'another_file/path' }
    @model_type = :events_page_url
    @model = EventsPageUrl
    @id = 8
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
