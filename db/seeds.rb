# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


# basic internal institutions for the development database
Institution.create( name: "Demo Institution", street_address: "1234 Main St.", city: "Williamstown", state: "MA", country: "USA", gps_longitude: -73.202887, gps_latitude: 42.710570, range: 10.0, configuration_id: 1, api_key: "DEMO01267" )
Institution.create( name: "Development", street_address: "123 Main St.", city: "Anytown", state: "NY", country: "USA", gps_longitude: -74.062958, gps_latitude: 40.869911, range: 15.0, configuration_id: 1, api_key: "DEVELOPMENT" )

# insert dining opportunities for Williams College
DiningOpportunity.create(dining_opportunity_type: "Breakfast", institution_id: 1)
DiningOpportunity.create(dining_opportunity_type: "Lunch", institution_id: 1)
DiningOpportunity.create(dining_opportunity_type: "Dinner", institution_id: 1)
DiningOpportunity.create(dining_opportunity_type: "Late Night", institution_id: 1)


# May also want to seed the configuration files for the database here


DiningOpportunity.create( dining_opportunity_type: "Breakfast", institution_id: 1 )
DiningOpportunity.create( dining_opportunity_type: "Lunch", institution_id: 1 )
DiningOpportunity.create( dining_opportunity_type: "Dinner", institution_id: 1 )
DiningOpportunity.create( dining_opportunity_type: "Brunch", institution_id: 1 )
DiningOpportunity.create( dining_opportunity_type: "Late Night", institution_id: 1 )

DiningPlace.create(institution_id: 3, name: "Paresky Whitmans Market", range: 0.0002)
DiningPlace.create(institution_id: 3, name: "Paresky Grab N Go", range: 0.0002)
DiningPlace.create(institution_id: 3, name: "Faculty House", range: 0.0002)

# MenuItems.create( name: nil, institution_id: nil, details_link: nil, small_price: nil, large_price: nil, combo_price: nil, created_at: nil, updated_at: nil, dining_opportunity_id: nil, dining_place_id: nil, date_available: nil, category: nil, serving_size: nil )


def seed_app_dining_periods
  start_hash = {"Breakfast" => 8, "Lunch" => 11, "Dinner" => 16, "Brunch" => 9, "Late Night" => 20}

  DiningOpportunity.all.each { |opp|
    DiningPlace.all.each { |dp|
      (0..6).each { |dow|
        DiningPeriod.create(start_time: Time.now.change(hour: start_hash[opp.dining_opportunity_type], min: rand(60)), end_time: Time.now.change(hour: start_hash[opp.dining_opportunity_type], min: rand(60)), day_of_week: dow, dining_opportunity_id: opp.id, dining_place_id: dp.id, institution_id: 1)
      }
    }
  }
end
