child :@dining_opportunity do
  attributes :id, :dining_opportunity_type, :institution_id, :created_at, :updated_at
end

node(:errors) {@dining_opportunity.errors.full_messages}
