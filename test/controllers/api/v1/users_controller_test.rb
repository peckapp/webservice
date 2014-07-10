require 'test_helper'
require 'ultimate_test_helper'

class UsersControllerTest < UltimateTestHelper


  def setup
    @controller = Api::V1::UsersController.new
    @attributes = [:id, :institution_id, :first_name, :last_name, :username, :blurb, :facebook_link, :active, :format]
    @params_index = {:format => :json}
    @params_show = {:id => 10, :institution_id => 1, :first_name => "John", :last_name => "Doe", :username => "jdoe", :active => true, :format => :json}
    @params_create = {:institution_id => 5, :first_name => "Sam", :last_name => "Adams", :username => "sadams", :active => true}
    @params_update = {:first_name => "John", :active => false}
    @model_type = :user
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end
end
