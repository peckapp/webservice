collection :@dining_opportunities

attributes :id, :dining_opportunity_type, :institution_id, :created_at, :updated_at

node :hours do |opp|
  @service_hours[opp.id]
end

node :start_time do |opp|
  @service_start[opp.id]
end

node :end_time do |opp|
  @service_start[opp.id]
end

node(:event_type) {"dining"}
