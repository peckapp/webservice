require 'test_helper'

class UsersControllerTest < ActionController::TestCase


  def setup
    @controller = Api::V1::UsersController.new
    @attributes = [:id, :institution_id, :first_name, :last_name, :username, :blurb, :facebook_link, :active, :format]
    @params_show = {:institution_id => 1, :first_name => "John", :last_name => "Doe", :username => "jdoe", :active => true, :format => :json}
    @params_create = {:institution_id => 5, :first_name => "Sam", :last_name => "Adams", :username => "sadams", :active => true}
    @params_update = {:first_name => "John", :active => false}
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "should get index" do
    get_index(@controller)
  end

  test "should get show" do
    get_show(@params_show, @controller, @attributes, 10)
  end

  test "should post create" do
    post_create(@params_create, @controller, :user)
  end

  test "should patch update" do
    patch_update(@params_update, @controller, 20, :user)
  end

  test "should delete destroy" do
    delete_destroy(@controller, 21)
  end
  
end
