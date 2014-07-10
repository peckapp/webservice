require 'test_helper'

class DiningOpportunitiesControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::DiningOpportunitiesController.new
    @attributes = [:id, :dining_opportunity_type, :institution_id, :format]
    @params_show = {:id => 11, :dining_opportunity_type => "dinner", :institution_id => 1, :format => :json}
    @params_create = {:dining_opportunity_type => "lunch", :institution_id => 2}
    @params_update = {:dining_opportunity_type => "breakfast"}
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
    post_create(@params_create, @controller, :dining_opportunity)
  end

  test "should patch update" do
    patch_update(@params_update, @controller, 20, :dining_opportunity)
  end

  test "should delete destroy" do
    delete_destroy(@controller, 21)
  end

end
