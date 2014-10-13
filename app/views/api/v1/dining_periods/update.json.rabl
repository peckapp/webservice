child :@dining_period do
  attributes :id, :institution_id, :start_date, :end_date, :day_of_week, :dining_opportunity_id, :dining_place_id, :created_at, :updated_at
end

node(:errors) {@dining_period.errors.full_messages}
