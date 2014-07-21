require 'test_helper'

class UltimateTestHelper < ActionController::TestCase

  def session_create
    session[:institution_id] = 1
    session[:user_id] = 3
    session[:api_key] = User.find(3).api_key

    @auth = {}

    request.session.each { |key, value| @auth[key] = value }
    return @auth
  end

  def super_create_user

    @controller = Api::V1::UsersController.new

    patch :super_create, :id => 3, :user => {:first_name => "Ju", :last_name => "Dr", :email => "bobbyboucher@williams.edu", :password => "testingpass", :password_confirmation => "testingpass"}, :authentication => session_create, :format => :json

    @controller = Api::V1::SessionsController.new

    post :create, :email => "bobbyboucher@williams.edu", :password => "testingpass", :authentication => session_create, :format => :json

    return assigns(:user)
  end

  test "should_get_index" do
    next unless is_subclass?
    @controller = @the_controller
    get :index, @params_index
    assert_response :success
  end

  test "should_get_show" do
    next unless is_subclass?
    @controller = @the_controller
    @params_show.keys.each do |attribute|
      unless @attributes.include? attribute
        assert(false, "Attribute not found in database table.")
      end
    end
    get :show, @params_show
    assert_response :success
  end

  test "should_post_create" do
    next unless is_subclass?
    the_user = super_create_user

    auth_params = session_create
    auth_params[:authentication_token] = the_user.authentication_token

    @controller = @the_controller
    post :create, {@model_type => @params_create, :authentication => auth_params, :format => :json}
    assert_response :success
  end

  test "should_patch_update" do
    next unless is_subclass?
    the_user = super_create_user

    auth_params = session_create
    auth_params[:authentication_token] = the_user.authentication_token

    @controller = @the_controller
    patch :update, {:id => @id, @model_type => @params_update, :authentication => auth_params, :format => :json}
    assert_response(:success)
  end

  test "should_delete_destroy" do
    next unless is_subclass?
    the_user = super_create_user

    auth_params = session_create
    auth_params[:authentication_token] = the_user.authentication_token

    @controller = @the_controller
    delete :destroy, {:format => :json, :id => @id, :authentication => auth_params}
    assert_response :success
  end

  private

    def is_subclass?
      self.class.superclass == UltimateTestHelper
    end
end
