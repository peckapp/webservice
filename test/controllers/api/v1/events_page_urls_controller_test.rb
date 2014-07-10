require 'test_helper'
require 'ultimate_test_helper'

class EventsPageUrlsControllerTest < UltimateTestHelper
  def setup
    @controller = Api::V1::EventsPageUrlsController.new
    @attributes = [:id, :institution_id, :url, :type, :format]
    @params_index = {:format => :json}
    @params_show = {:id => 11, :format => :json}
    @params_create = {:institution_id => 2, :url => "file/path"}
    @params_update = {:url => "another_file/path"}
    @model_type = :events_page_url
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
