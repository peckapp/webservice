require 'test_helper'
require 'ultimate_test_helper'

class UsersControllerTest < UltimateTestHelper


  def setup
    @controller = Api::V1::UsersController.new
    @attributes = [:id, :institution_id, :first_name, :last_name, :username, :blurb, :facebook_link, :active, :format]
    @params_index = {:format => :json}
    @params_show = {:id => 10, :institution_id => 1, :format => :json}
    @params_create = {:institution_id => 5}
    @params_update = {:first_name => "John", :active => false}
    @model_type = :user
    @id = 11
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "anonymous user creation" do
    post :create, :user => @params_create, :format => :json
    user = assigns(:user)
    assert_not_nil user.id
    assert_not_nil user.api_key
  end
end
