require 'test_helper'

class SessionFlowsTest < ActionDispatch::IntegrationTest

  ##########################################
  ##                                      ##
  ##       Session integration tests      ##
  ##                                      ##
  ##########################################

  test "super create, login, create stuff" do
    https!

    # super create user
    user = super_create_user

    # attempt to super create w/ wrong password
    super_create_fail

    # authenticate user
    login(user)

    # create a circle
    create_circle

    # create an event
    create_simple_event

    # change a user's password
    change_user_password

    # fail to change a user's password
    change_user_password_fail

    delete_subscriptions

  end

  ##########################################
  ##                                      ##
  ##            End of testing            ##
  ##        Start of helper methods       ##
  ##                                      ##
  ##########################################

  private

    def super_create_user
      #super create user
      patch "/api/users/1/super_create", :user => {:first_name => "John", :last_name => "Doe", :email => "jdoe@williams.edu", :password => "testingabcd", :password_confirmation => "testingabcd"}, :authentication => {:user_id => 1, :institution_id => 1, :api_key => User.find(1).api_key}, :format => :json
      user = assigns(:user)
      assert_response :success, "no response from database"
      assert_not_nil user, "user was not super created properly"
      assert_not_nil user.authentication_token
      return user
    end

    def super_create_fail
      #super create user
      patch "/api/users/2/super_create", :user => {:first_name => "John", :last_name => "Doe", :email => "jdoe1@williams.edu", :password => "anothertest", :password_confirmation => "wrongpassword"}, :authentication => {:user_id => 2, :institution_id => 1, :api_key => User.find(1).api_key },:format => :json
      user = assigns(:user)
      assert_response :unauthorized, "authorized somehow"
      assert_nil user
    end

    def login(user)
      open_session do |sess|
        sess.https!
        sess.post "api/access", :user => {email: "jdoe@williams.edu", password: "testingabcd"}, :authentication => {:user_id => 1, :institution_id => 1, :api_key => User.find(1).api_key }, :format => :json
        assert_not_nil session[:user_id], "the session does not exist"
      end
    end

    def create_circle
      post "api/circles", :circle => {:institution_id => 3, :user_id => 1, :circle_name => "CIRCLE", :circle_member_ids => [1,2,3,4]}, :authentication => {:user_id => 1, :institution_id => 1, :api_key => User.find(1).api_key, :authentication_token => User.find(1).authentication_token}, :format => :json
      circle = assigns(:circle)
      assert_response :success, "no response from database"
      assert_not_nil circle.id, "circle was not created properly"
    end

    def create_simple_event
      post "api/simple_events", :simple_event => {:title => "Super Duper Dope Event", :institution_id => 1, :user_id => 3, :public => true, :start_date => DateTime.current, :end_date => DateTime.current + 1.hour}, :authentication => {:user_id => 1, :institution_id => 1, :api_key => User.find(1).api_key, :authentication_token => User.find(1).authentication_token}, :format => :json
      event = assigns(:simple_event)
      assert_response :success, "no response from database"
      assert_not_nil event.id, "simple event was not created properly"
    end

    def change_user_password
      patch "api/users/1/change_password", :user => {:password => "testingabcd", :new_password => {:password => "testing2", :password_confirmation => "testing2"}}, :authentication => {:user_id => 1, :institution_id => 1, :api_key => User.find(1).api_key }, :format => :json
      assert_response :success, "we've got a problem with changing passwords"
      assert assigns(:user).old_pass_match
    end

    def change_user_password_fail
      patch "api/users/1/change_password", :user => {:password => "wrongpassword", :new_password => {:password => "testingstuff", :password_confirmation => "testingstuff"}}, :authentication => {:user_id => 1, :institution_id => 1, :api_key => User.find(1).api_key }, :format => :json
      assert_response :success, "we've got a problem with failing to change passwords"
      assert_not assigns(:user).old_pass_match
    end

    def delete_subscriptions
      delete "api/subscriptions/1?subscriptions=[1,2,3,4]", :authentication => {:user_id => 1, :institution_id => 1, :api_key => User.find(1).api_key }, :format => :json
      assert_response :success, "problem deleting subscriptions"
    end
end
