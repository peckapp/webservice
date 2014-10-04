require 'test_helper'

class ExploreControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::ExploreController.new
  end

  def session_create
    session[:institution_id] = 1
    session[:user_id] = 3
    session[:api_key] = User.find(3).api_key

    @auth = {}

    request.session.each { |key, value| @auth[key] = value }
    @auth
  end

  test 'should get index' do
    get :index, format: :json, authentication: session_create
    assert_response :success, 'Index action not successful'

    assert assigns['explore_events'].any?, 'Events array must be non-empty'
    assert assigns['explore_announcements'].any?, 'Announcements array must be non-empty'
    assert assigns['explore_athletics'].any?, 'Athletics array must be non-empty'
  end
end
