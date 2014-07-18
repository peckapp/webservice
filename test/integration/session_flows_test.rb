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

    puts "THE USER: #{user}"

    # attempt to super create w/ wrong password
    # super_create_fail

    # authenticate user
    login(user)

    # create a circle
    create_circle

    # create an event
    create_simple_event

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
      patch "/api/users/1/super_create", :user => {:first_name => "J", :last_name => "D", :email => "jdoe@williams.edu", :password => "testing", :password_confirmation => "testing"}, :authentication => {:user_id => 21, :institution_id => 1, :api_key => "1111111111111111111111111" }, :format => :json
      user = assigns(:user)
      assert_response :success, "no response from database"
      assert_not_nil user, "user was not super created properly"
      return user
    end

    # def super_create_fail
    #   #super create user
    #   patch "/api/users/2/super_create", :user => {:first_name => "John", :last_name => "Doe", :email => "jdoe1@williams.edu", :password => "anothertest", :password_confirmation => "wrongpassword"}, :format => :json
    #   user = assigns(:user)
    #   assert_response :success, "no response from database"
    #   assert_nil user.password_salt, "pw salt should be nil with wrong pw confirmation"
    #   assert_nil user.password_hash, "pw hash should be nil with wrong pw confirmation"
    # end

    def login(user)
      open_session do |sess|
        sess.https!
        sess.post "api/sessions", email: "jdoe@williams.edu", password: "testing", :authentication => {:user_id => 21, :institution_id => 1, :api_key => "1111111111111111111111111" }, :format => :json
        assert_not_nil session[:user_id], "the session does not exist"
      end
    end

    def create_circle
      post "api/circles", :circle => {:institution_id => 3, :user_id => 59, :circle_name => "CIRCLE"}, :authentication => {:user_id => 21, :institution_id => 1, :api_key => "1111111111111111111111111" }, :format => :json
      circle = assigns(:circle)
      assert_response :success, "no response from database"
      assert_not_nil circle.id, "circle was not created properly"
    end

    def create_simple_event
      post "api/simple_events", :simple_event => {:title => "Super Duper Dope Event", :institution_id => 1, :user_id => 3, :open => true, :start_date => DateTime.current, :end_date => DateTime.current + 1.hour}, :authentication => {:user_id => 21, :institution_id => 1, :api_key => "1111111111111111111111111" }, :format => :json
      event = assigns(:simple_event)
      assert_response :success, "no response from database"
      assert_not_nil event.id, "simple event was not created properly"
    end
end
