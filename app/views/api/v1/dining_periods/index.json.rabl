collection :@dining_periods

attributes :id, :institution_id, :day_of_week, :dining_opportunity_id, :dining_place_id, :created_at, :updated_at

node :start_time do |per|
  per.cur_week_start_time.to_f
end

node :end_date do |per|
  per.cur_week_end_time.to_f
end
