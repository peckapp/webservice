require 'test_helper'
require 'ultimate_test_helper'

class UsersControllerTest < UltimateTestHelper


  def setup
    @the_controller = Api::V1::UsersController.new
    @attributes = [:id, :institution_id, :first_name, :last_name, :username, :blurb, :facebook_link, :active, :format, :authentication]
    @params_index = {:format => :json, :authentication => session_create}
    @params_show = {:id => 10, :institution_id => 1, :format => :json, :authentication => session_create}
    @params_create = {:institution_id => 1}
    @params_update = {:first_name => "John", :active => false}
    @params_super_create = {:first_name => "John", :last_name => "Doe", :email => "jdoe@williams.edu", :password => "testagain", :password_confirmation => "testagain"}
    @model_type = :user
    @model = User
    @id = 3
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "anonymous user creation" do
    @controller = @the_controller

    post :create, :user => @params_create, :format => :json, :authentication => session_create
    user = assigns(:user)
    assert_not_nil user.id
    assert_not_nil user.api_key
  end

  test "should patch super create" do
    @controller = @the_controller

    patch :super_create, :id => @id, @model_type => @params_super_create, :authentication => session_create, :format => :json
    assert_response :success
  end

  test "should not patch super create" do
    @controller = @the_controller

    patch :super_create, :id => @id, @model_type => {:first_name => "Andy", :last_name => "Smith", :email => "asmith@amherst.edu", :password => "holymama", :password_confirmation => "nope"}, :authentication => session_create, :format => :json
    user = assigns(:user)
    assert_nil user.password_salt
    assert_nil user.password_hash
  end
end
