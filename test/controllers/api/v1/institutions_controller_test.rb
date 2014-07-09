require 'test_helper'

class InstitutionsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::InstitutionsController.new
    @attributes = [:id, :name, :street_address, :city, :state, :country, :gps_longitude, :gps_latitude, :range, :configuration_id, :api_key, :format]
    @params_show = {:id => 1, :configuration_id => 1, :format => :json}
    @params_create = {:name => "Some Institution", :street_address => "institution_street", :city => "Boston", :state => "MA", :country => "USA", gps_longitude: (rand * 100.0), gps_latitude: (rand * 100.0), range: (rand * 0.01), :configuration_id => 1, :api_key => SecureRandom.hex(8)}
    @params_update = {:name => "Sample Institution"}
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  # test "should get index" do
  #   get_index(@controller)
  # end
  #
  # test "should get show" do
  #   get_show(@params_show, @controller, @attributes)
  # end
  #
  # test "should post create" do
  #   post_create(@params_create, @controller, :institution)
  # end
  #
  # test "should patch update" do
  #   patch_update(@params_update, @controller, 2, :institution)
  # end
  #
  # test "should delete destroy" do
  #   delete_destroy(@controller, 2)
  # end
end
