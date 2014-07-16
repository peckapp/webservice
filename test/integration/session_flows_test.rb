require 'test_helper'

class SessionFlowsTest < ActionDispatch::IntegrationTest

  test "login and browse" do
      https!
      patch "/api/users/2/super_create", :user => {:first_name => "John", :last_name => "Doe", :email => "jdoe@williams.edu", :password => "test", :password_confirmation => "test"}, :format => :json
      user = assigns(:user)
      assert_response :success
      assert_not_nil user

      authenticated_user = login(user)

      create_circle
  end

  private

    def create_circle
        post "api/circles", :circle => {:institution_id => 3, :user_id => 59, :circle_name => "CIRCLE"}, :format => :json
        assert_response :success
        assert assigns(:circle)
    end

    def login(user)
      open_session do |sess|
        sess.https!
        sess.post "api/sessions", email: "jdoe@williams.edu", password: "test", :format => :json
        assert_not_nil session[:user_id]
      end
    end
end
