require 'test_helper'

class CircleMemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "method test" do
    CircleMember.date_added_is_date?
    assert true
  end
end
