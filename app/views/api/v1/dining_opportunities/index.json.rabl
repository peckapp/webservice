collection :@dining_opportunities

attributes :id, :dining_opportunity_type, :institution_id, :created_at, :updated_at

node :start_time do |opp|
  @service_start[opp.id]
end

node :end_time do |opp|
  @service_end[opp.id]
end

node(:event_type) {"dining"}
