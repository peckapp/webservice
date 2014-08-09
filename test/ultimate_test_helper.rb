require 'test_helper'

class UltimateTestHelper < ActionController::TestCase
  include Devise::TestHelpers
  include Warden::Test::Helpers
  Warden.test_mode!

  def teardown
    Warden.test_reset!
  end

  def session_create(auth_token = nil)
    session[:institution_id] = 1
    session[:user_id] = 3
    session[:api_key] = User.find(3).api_key

    @auth = {}

    request.session.each { |key, value| @auth[key] = value }
    @auth[:authentication_token] = auth_token
    return @auth
  end

  def super_create_user

    @controller = Api::V1::UsersController.new

    patch :super_create, :id => 3, :user => {:first_name => "Ju", :last_name => "Dr", :email => "bobbyboucher@williams.edu", :password => "testingpass", :password_confirmation => "testingpass"}, :authentication => session_create, :format => :json
    user = assigns(:user)
    auth_token = user.authentication_token

    @controller = Api::V1::AccessController.new

    post :create, :user => {:email => "bobbyboucher@williams.edu", :password => "testingpass", :udid => "bob"}, :authentication => session_create, :format => :json

    return assigns(:user)
  end

  test "should_get_index" do
    next unless is_subclass? && is_controller?
    the_user = super_create_user

    auth_params = session_create
    auth_params[:authentication_token] = the_user.authentication_token

    @controller = @the_controller

    # circles and circle members require logging in.
    if is_circle_members_controller? || is_circles_controller?
      get :index, {:format => :json, :authentication => auth_params}
      assert_response :success
    else
      get :index, @params_index
      assert_response :success
    end
  end

  test "should_get_show" do
    next unless is_subclass? && is_controller?
    the_user = super_create_user

    auth_params = session_create
    auth_params[:authentication_token] = the_user.authentication_token

    @controller = @the_controller
    @params_show.keys.each do |attribute|
      unless @attributes.include? attribute
        assert(false, "Attribute not found in database table.")
      end
    end

    # circles and circle members require logging in.
    if is_circle_members_controller? || is_circles_controller?
      get :show, {:format => :json, :id => @id, :authentication => auth_params}
      assert_response :success
      assert_not_nil @model.find(@id)
    else
      get :show, @params_show
      assert_response :success
      assert_not_nil @model.find(@id)
    end
  end

  test "should_post_create" do
    next unless is_subclass? && is_controller?
    the_user = super_create_user

    auth_params = session_create
    auth_params[:authentication_token] = the_user.authentication_token

    @controller = @the_controller

    if is_subscriptions_controller?
      post :create, {:subscriptions => @params_create, :authentication => auth_params, :format => :json}
      assert_response :success
      assigns(:subscriptions).each do |sub|
        assert_not_nil sub
      end

      # anonymous user creation
    elsif is_users_controller?
      post :create, {:udid => "hello", :format => :json, :authentication => session_create}
      user = assigns(:user)
      assert_not_nil user.id
      assert_not_nil user.api_key
    else
      post :create, {@model_type => @params_create, :authentication => auth_params, :format => :json}
      assert_response :success
      # assert_not_nil assigns(@model_type)
    end
  end

  test "should_patch_update" do
    next unless is_subclass? && is_controller?
    the_user = super_create_user

    auth_params = session_create
    auth_params[:authentication_token] = the_user.authentication_token

    @controller = @the_controller
    patch :update, {:id => @id, @model_type => @params_update, :authentication => auth_params, :format => :json}

    assert_response :success
    assert_not_nil assigns(@model_type)
  end

  test "should_patch_accept" do
    next unless is_subclass? && is_controller? && is_circle_members_controller?
    the_user = super_create_user

    auth_params = session_create
    auth_params[:authentication_token] = the_user.authentication_token

    @controller = @the_controller
    patch :accept, {:id => @id, :peck_id => 1, :authentication => auth_params, :format => :json}

    peck = assigns(:peck)
    assert_response :success
    assert_not_nil peck
  end

  test "should_delete_destroy" do
    next unless is_subclass? && is_controller?
    the_user = super_create_user

    auth_params = session_create
    auth_params[:authentication_token] = the_user.authentication_token

    @controller = @the_controller

    if is_subscriptions_controller? || is_event_attendees_controller?
      delete :destroy, {:format => :json, :authentication => auth_params, @model_type => @params_delete}
      assert_response :success
    elsif is_circle_members_controller?
      delete :leave_circle, {:format => :json, :authentication => auth_params, @model_type => @params_delete}
      assert_response :success
    else
      delete :destroy, {:format => :json, :id => @id, :authentication => auth_params}
      assert_response :success
    end
  end

  private
    def is_subclass?
      self.class.superclass == UltimateTestHelper
    end

    def is_circles_controller?
      @class && @class == CirclesControllerTest
    end

    def is_circle_members_controller?
      @class && @class == CircleMembersControllerTest
    end

    def is_event_attendees_controller?
      @class && @class == EventAttendeesControllerTest
    end

    def is_subscriptions_controller?
      @class && @class == SubscriptionsControllerTest
    end

    def is_users_controller?
      @class && @class == UsersControllerTest
    end

    def is_controller?
      defined? @the_controller
    end
end
