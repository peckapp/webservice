require 'test_helper'

class MenuItemsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::MenuItemsController.new
    @attributes = [:name, :institution_id, :details_link, :small_price, :large_price, :combo_price, :dining_opportunity_id, :dining_place_id, :dining_place_id, :date_available]
    @params_show = {}
    @params_create = {name: "new menu item", institution_id: 1, dining_opportunity_id: 2, dining_place_id: 6, date_available: DateTime.current}
    @params_update = {name: "updated menu item"}

    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "should get index" do
    get_index(@controller)
  end

  test "should get show" do
    get_show(@params_show, @controller, @attributes)
  end

  test "should post create" do
    post_create(@params_create, @controller, :menu_item)
  end

  test "should patch update" do
    patch_update(@params_update, @controller, 20, :menu_item)
  end

  test "should delete destroy" do
    delete_destroy(@controller, 22)
  end
end
