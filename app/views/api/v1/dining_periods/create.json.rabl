object :@dining_period

attributes :id, :start_time, :end_time, :day_of_week, :created_at, :updated_at

node(:dining_place_id) {@dining_place_id}

node(:dining_opportunity_id) {@dining_opportunity_id}

node(:menu_item_id) {@menu_item_id}
