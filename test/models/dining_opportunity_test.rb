require 'test_helper'

class DiningOpportunityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @all_opps = DiningOpportunity.all
    @first_opp = @all_opps.first
  end

  def teardown

  end

  test "earliest start before latest end for all dining opportunities"

  end

  test "date time for week day method works properly"

  end

  test "nearest_week_day method works properly"\
    today = DateTime.now
    
    wd1 = @first_opp.nearest_week_day((today + 1.days).wday)
    assert_difference(wd1 - today.wday, 1, "tomorrow should be one day after today")

    wd2 = @first_opp.nearest_week_day((today - 1.days).wday)
    assert_difference(wd2 - today.wday, -1, "yesterday should be one day before today")
  end

end
