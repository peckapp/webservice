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
