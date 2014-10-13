object :@dining_place

attributes :id, :institution_id, :name, :details_link, :gps_longitude, :gps_latitude, :range, :created_at, :updated_at

node :image do
  @dining_place.image.url(:home)
end

node :blurred_image do
  @dining_place.image.url(:blurred)
end
