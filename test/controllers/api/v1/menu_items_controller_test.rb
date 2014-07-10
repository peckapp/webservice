require 'test_helper'
require 'ultimate_test_helper'

class MenuItemsControllerTest < UltimateTestHelper
  def setup
    @controller = Api::V1::MenuItemsController.new
    @attributes = [:id, :name, :institution_id, :details_link, :small_price, :large_price, :combo_price, :dining_opportunity_id, :dining_place_id, :dining_place_id, :date_available, :format]
    @params_index = {:format => :json}
    @params_show = {:id => 12, :format => :json}
    @params_create = {name: "new menu item", institution_id: 1, dining_opportunity_id: 2, dining_place_id: 6, date_available: DateTime.current}
    @params_update = {name: "updated menu item"}
    @model_type = :menu_item
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
