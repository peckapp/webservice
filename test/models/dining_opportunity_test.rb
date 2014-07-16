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
