child :@dining_place do
  attributes :id, :institution_id, :name, :details_link, :gps_longitude, :gps_latitude, :range, :created_at, :updated_at
  node(:dining_opportunity_id) {@dining_opportunity_id}
end

node(:errors) {@dining_place.errors.full_messages}
