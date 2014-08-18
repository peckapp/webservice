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

  test 'earliest start and latest end works properly and all dining periods have each value' do

    inst_id = 1

    (0..6).each do |dow|

      early_late = DiningOpportunity.earliest_start_latest_end(dow, inst_id)

      DiningPeriod.where(day_of_week: dow).pluck(:dining_opportunity_id).each do |opp_id|

        early = early_late[opp_id][0]
        late = early_late[opp_id][1]

        next if early.blank? || late.blank?

        opp_type = DiningOpportunity.find(opp_id).dining_opportunity_type

        # assert start
        assert(!early.blank?, "the following opportunity has no start: day # #{dow} for #{opp_type}")

        # assert end
        assert(!late.blank?, "the following opportunity has no end: day # #{dow} for #{opp_type}")

        # assert start is before end
        assert(early < late, 'earliest start must always be before latest end')
      end
    end
  end
end
