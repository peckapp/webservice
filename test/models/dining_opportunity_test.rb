require 'test_helper'

class DiningOpportunityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @first_opp = DiningOpportunity.all.first
  end

  def teardown

  end

  test "date time for week day method works properly" do
    (0..6).each { |dow|
      (10..14).each { |hr|
        result = @first_opp.send(:date_time_for_week_day,dow, DateTime.now.midnight + hr.hours + 30.minutes)
        assert(result.hour == hr, "inputted hour must equal outputted")
        assert(result.min == 30, "inputted minutes must equal outputted")
        assert(result.wday == dow, "inputted day of week must equal outputted")
      }
    }

  end

  test "nearest_week_day method works properly" do
    today = DateTime.now

    (0..6).each { |dow|
      assert(@first_opp.send(:nearest_week_day,dow).wday == dow, "resulting day should equal requested day")
    }

    wd1 = @first_opp.send(:nearest_week_day,(today + 1.days).wday).wday
    assert(wd1 - today.wday == 1, "tomorrow should be one day after today")

    wd2 = @first_opp.send(:nearest_week_day,(today - 1.days).wday).wday
    assert(wd2 - today.wday == -1, "yesterday should be one day before today")
  end

  test "earliest start and latest end works properly and all dining periods have each value" do
    (0..6).each { |dow|
      DiningPeriod.where(:day_of_week => dow).pluck(:dining_opportunity_id).each { |opp_id|
        early, late = DiningOpportunity.find(opp_id).earliest_start_latest_end(dow)

        # assert start
        assert( ! early.blank? , "the following opportunity has no start: day # #{dow} for #{DiningOpportunity.find(opp_id).dining_opportunity_type}")

        # assert end
        assert( ! late.blank? , "the following opportunity has no end: day # #{dow} for #{DiningOpportunity.find(opp_id).dining_opportunity_type}")

        # assert start is before end
        assert(early < late, "earliest start must always be before latest end")
      }
    }
  end

end
