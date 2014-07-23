require 'test_helper'
require 'ultimate_test_helper'


class UserTest < UltimateTestHelper


  @is_model = false

  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = super_create_user
  end

  test "authenticate handles nil values properly" do
    assert_nil User.authenticate(nil, nil), "authenticating with nil parameters must return nil"
  end

  test "authenticate properly confirms user credentials" do
    # same password as is used in UltimateTestHelper supercreate method
    assert_equal User.authenticate(@user.email, "testingpass"), @user, "authenticating with real parameters must return the same user"
  end
end
