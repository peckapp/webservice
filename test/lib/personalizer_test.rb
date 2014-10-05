require 'test_helper'

# excersises all functionality of the personalizer class
class PersonalizerTest < ActionController::TestCase
  def setup
    @personalizer = Personalizer.new

    circle_members = CircleMember.where(circle_id: 5)

    circle_member_ids = circle_members.map { |u| u.id }
    @users = User.where(id: circle_member_ids)
  end

  def teardown
  end

  # TODO: the perform tests need inputted scores to actually do anything useful

  ### USELESS ###
  test 'perform_events method works properly for simple_events' do
    @users.each do |user|
      scores = @personalizer.perform_events(SimpleEvent, user.id, user.institution_id)
      assert_not_nil scores, 'similar subscribers returned by personalizer must not be nil'
    end
  end

  ### USELESS ###
  test 'perform_events method works properly for athletic_events' do
    @users.each do |user|
      scores = @personalizer.perform_events(AthleticEvent, user.id, user.institution_id)
      assert_not_nil scores, 'similar subscribers returned by personalizer must not be nil'
    end
  end

  ### USELESS ###
  test 'perform_announcements method works properly' do
    @users.each do |user|
      scores = @personalizer.perform_announcements(user.id, user.institution_id)
      assert_not_nil scores, 'similar subscribers returned by personalizer must not be nil'
    end
  end

  test 'top friends method operates properly' do
    @users.each do |user|
      tf = @personalizer.top_friends(user.id)
      assert_not_nil tf, 'top friends returned by personalizer must not be nil'
    end
  end

  test 'similar_subscribers operates properly' do
    @users.each do |user|
      ss = @personalizer.similar_subscribers(user.id, user.institution_id)
      assert_not_nil ss, 'similar subscribers returned by personalizer must not be nil'
    end
  end
end
