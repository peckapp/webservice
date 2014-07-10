collection :@dining_opportunities

attributes :id, :dining_opportunity_type, :institution_id, :created_at, :updated_at

node :hours do |opp|
  puts opp.id
  @service_hours[opp.id]
end

node(:event_type) {"dining"}
