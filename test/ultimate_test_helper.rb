require 'test_helper'

class UltimateTestHelper < ActionController::TestCase
  def setup
    # setup a session for functional testing
    @controller = Api::V1::UsersController.new

    # create a private user
    patch :super_create, :id => 3, :user => {:first_name => "Ju", :last_name => "Dr", :email => "bobbyboucher@williams.edu", :password => "testingpass", :password_confirmation => "testingpass"}, :format => :json
    user = assigns(:user)
    assert_response :success, "no response from database"
    assert_not_nil user, "user was not super created properly"

    # authenticate user for new session
    the_user = User.authenticate("bobbyboucher@williams.edu", "testingpass")

    # start session (provide session variable :user_id when making requests)
    session[:institution_id] = User.find(3).institution_id
    if the_user
      session[:user_id] = the_user.id
    end
  end

  test "should_get_index" do
    next unless is_subclass?
    get :index, @params_index
    assert_response :success
  end

  test "should_get_show" do
    next unless is_subclass?
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
     post :create, {@model_type => @params_create, :format => :json}, {:user_id => 3}
     assert_response :success
  end

  test "should_patch_update" do
    next unless is_subclass?
    patch :update, {:id => @id, @model_type => @params_update, :format => :json}, {:user_id => 3}
    assert_response(:success)
  end

  test "should_delete_destroy" do
    next unless is_subclass?
    delete :destroy, {:format => :json, :id => @id}, {:user_id => 3}
    assert_response :success
  end

  private

    def is_subclass?
      self.class.superclass == UltimateTestHelper
    end
end
