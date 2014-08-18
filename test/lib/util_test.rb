require 'test_helper'

class UtilTest < ActiveSupport::TestCase
  test 'date time for week day method works properly' do
    (0..6).each do |dow|
      (10..14).each do |hr|
        result = Util.send(:date_time_for_week_day, dow, Time.now.midnight + hr.hours + 30.minutes)
        assert(result.hour == hr, 'inputted hour must equal outputted')
        assert(result.min == 30, 'inputted minutes must equal outputted')
        assert(result.wday == dow, 'inputted day of week must equal outputted')
      end
    end

  end

  test 'nearest_week_day method works properly for yesterday and tomorrow' do
    today = DateTime.now

    (0..6).each do |dow|
      assert_equal(Util.send(:nearest_week_day, dow).wday, dow, 'resulting day should equal requested day')
    end

    wd1 = Util.send(:nearest_week_day, (today + 1.days).wday).wday
    assert_equal(wd1 - today.wday, 1, 'tomorrow should be one day after today')

    wd2 = Util.send(:nearest_week_day, (today - 1.days).wday).wday
    assert_equal(wd2 - today.wday, -1, 'yesterday should be one day before today')
  end
end
