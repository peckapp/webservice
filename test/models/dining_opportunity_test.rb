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

      early_late = DiningOpportunity.earliest_start_latest_end(dow)

      DiningPeriod.where(:day_of_week => dow).pluck(:dining_opportunity_id).each { |opp_id|
        
        early = early_late[opp_id][0]
        late = early_late[opp_id][1]

        # assert start
        puts "----> HELLO 1"
        assert( ! early.blank? , "the following opportunity has no start: day # #{dow} for #{DiningOpportunity.find(opp_id).dining_opportunity_type}")
        puts "----> HELLO 2"

        # assert end
        assert( ! late.blank? , "the following opportunity has no end: day # #{dow} for #{DiningOpportunity.find(opp_id).dining_opportunity_type}")

        # assert start is before end
        assert(early < late, "earliest start must always be before latest end")
      }
    }
  end

end
