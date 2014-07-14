child :@location do
  attributes :id, :institution_id, :name, :gps_longitude, :gps_latitude, :range, :created_at, :updated_at
end

node(:errors) {@location.errors.full_messages}
