object :@dining_place

attributes :id, :institution_id, :name, :details_link, :gps_longitude, :gps_latitude, :range, :created_at, :updated_at

node(:dining_period_id) {@dining_period_id}

node(:menu_item_id) {@menu_item_id}
