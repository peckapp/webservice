require 'test_helper'

class InstitutionsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::InstitutionsController.new
    @attributes = [:name, :street_address, :city, :state, :country, :gps_longitude, :gps_latitude, :configuration_id, :api_key]
    @params_show = {}
    @params_create = {name: "inst", street_address: "addr", city: "city", state: "state", country: "usa", gps_longitude: (rand * 100.0), gps_latitude: (rand * 100.0), range: (rand * 0.01), configuration_id: 1, api_key: SecureRandom.hex(8) }
    @params_update = {name: "updated inst name"}
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "should get index" do
    get_index(@controller)
  end

  test "should get show" do
    get_show(@params_show, @controller, @attributes, 3)
  end

  test "should post create" do
    post_create(@params_create, @controller, :institution)
  end

  test "should patch update" do
    patch_update(@params_update, @controller, 5, :institution)
  end

  test "should delete destroy" do
    delete_destroy(@controller, 7)
  end
end
