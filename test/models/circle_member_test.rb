require 'test_helper'

class CircleMemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # test "validations test" do
  #   ### Why does ruby on rails automatically convert invalid types to their valid types? For example, "bob" is a string but it's getting automatically converted to an integer.
  #   member = CircleMember.new(:circle_id => 1, :user_id => "bob", :invited_by => 3, :institution_id => 4)
  #   assert member.valid_circle_id.blank?, "Invalid circle_id"
  #   assert_kind_of(Fixnum, member.circle_id, "Circle id not a fixnum")
  #
  #   assert member.valid_user_id.blank?, "Invalid user_id"
  #   assert_kind_of(Fixnum, member.user_id, "User id not a fixnum")
  #
  #   assert member.valid_invited_by.blank?, "Invalid invited_by"
  #   assert_kind_of(Fixnum, member.invited_by, "Invited by is not a fixnum")
  #
  #   assert member.valid_institution_id.blank?, "Invalid institution_id"
  #   assert_kind_of(Fixnum, member.institution_id, "Institution id is not a fixnum")
  #
  #   assert member.save
  # end
end
