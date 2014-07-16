require 'test_helper'

class DiningPeriodTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "cur week start time returns correct datetime" do
    DiningPeriod.all.each do |period|
      cur_week_helper(period.start_time, period.cur_week_start_time, period.day_of_week)
    end
  end

  test "cur week end time returns correct datetime" do
    DiningPeriod.all.each do |period|
      cur_week_helper(period.end_time, period.cur_week_end_time, period.day_of_week)
    end
  end


  private

    def cur_week_helper(base_time, cur_date_time, day_of_week)
      assert_equal(base_time, Time.parse(cur_date_time.to_s), "time must be equal to original in datetime returned by cur_week methods" )
      assert_equal(day_of_week, cur_date_time.wday, "day of week must be equal in period specification and in datetime returned by cur_week methods")
    end

end
