collection :@dining_opportunity_event_ids

node :dining_opportunity_type do |uniq_id|
  @dining_opportunities[uniq_id].dining_opportunity_type
end

node :institution_id do |uniq_id|
  @dining_opportunities[uniq_id].institution_id
end

node :created_at do |uniq_id|
  @dining_opportunities[uniq_id].created_at
end

node :updated_at do |uniq_id|
  @dining_opportunities[uniq_id].updated_at
end

node :id do |uniq_id|
  uniq_id
end

node :start_time do |uniq_id|
  @service_start[uniq_id].to_f
end

node :end_time do |uniq_id|
  @service_end[uniq_id].to_f
end

node(:event_type) { 'dining' }
