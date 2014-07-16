#various utilities for the rails app

class Util


  # don't care about the error thrown here, will return nil is Object isn't found
  def self.class_from_string(str)
    begin
      str.split('::').inject(Object) do |mod, class_name|
        mod.const_get(class_name)
      end
    end
  end

  # These methods deliver the proper DateTime for the specified week_day parameter coming from the controller

  def self.date_time_for_week_day(day_of_week, time)
    if ! day_of_week.blank? && ! time.blank?
      day = nearest_week_day(day_of_week)
      return day.change(hour: time.hour, min: time.min)
    end
  end

  def self.nearest_week_day(day_of_week)
    if ! day_of_week.blank?
      cur = DateTime.now.noon.wday
      # the amount to shift the date forward by
      shift = cur - day_of_week
      return DateTime.now.noon - shift.days
    end
  end

end
