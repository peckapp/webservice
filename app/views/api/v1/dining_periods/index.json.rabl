collection :@dining_periods

attributes :id, :institution_id, :day_of_week, :dining_opportunity_id, :dining_place_id, :created_at, :updated_at

node :start_time do |opp|
  @period_start[opp.id].to_f
end

node :end_time do |opp|
  @period_end[opp.id].to_f
end
