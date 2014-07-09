require 'test_helper'

class UltimateTestHelper < ActionController::TestCase
  def setup
  end

  test "should_get_index" do
    get :index, :format => :json
    assert_response :success
  end

  test "should_get_show" do
    @params_show.keys.each do |attribute|
      unless @attributes.include? attribute
        assert(false, "Attribute not found in database table.")
      end
    end
    get :show, @params_show
    assert_response :success
  end

  test "should_post_create" do
     post :create, @model_type => @params_create, :format => :json
     assert_response :success
  end

  test "should_patch_update" do
    patch :update, :id => @id, @model_type => @params_update, :format => :json
    assert_response(:success)
  end

  test "should_delete_destroy" do
    delete :destroy, :format => :json, :id => @id
    assert_response :success
  end

end
