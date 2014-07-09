collection :@dining_places

attributes :id, :institution_id, :name, :details_link, :gps_longitude, :gps_latitude, :range, :created_at, :updated_at

node :hours do |dp|
   @service_hours[dp.id]
end
