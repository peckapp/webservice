ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
    def get_index(controller)
      @controller = controller
      get :index, :format => :json
      assert_response :success
    end

    def get_show(params_show, controller, attributes, id)
      @controller = controller
      get :show, :format => :json, :id => id
      params_show.keys.each do |attribute|
        unless attributes.include? attribute
          assert(false, "Attribute not found in database table.")
        end
      end
      get :show, params_show
      assert_response :success
    end

    def post_create(params_create, controller)
       @controller = controller
       post :create, push_notification: params_create, :format => :json
       assert_response :success
    end

    def patch_update(params_update, controller, id)
      @controller = controller
      patch :update, :id => id, push_notification: params_update, :format => :json
      assert_response(:success)
    end

    def delete_destroy(controller, id)
      @controller = controller
      delete :destroy, :format => :json, :id => id
      assert_response :success
    end
end
