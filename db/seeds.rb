# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# def seed_all
#   create_misc
#   create_institutions
#   create_williams_dining_opps
#   create_williams_dining_places
#   create_dining_opps
#   seed_app_dining_periods
#   seed_williams_rss_scraping
# end

def create_misc
  (1..10).each do |n|
    Circle.create institution_id: 1, user_id: 1, circle_name: "Circle #{n}"
  end

  (1.50).each do |n|
    User.create institution_id: (rand(3) + 1), first_name: "name#{n}", last_name: "last#{n}", email: "test@example.edu"
  end
end


# basic internal institutions for the development database
def create_institutions
  Institution.create( name: "Demo Institution", street_address: "1234 Main St.", city: "Williamstown", state: "MA", country: "USA", gps_longitude: -73.202887, gps_latitude: 42.710570, range: 0.002, configuration_id: 1, api_key: "DEMO01267" )
  Institution.create( name: "Development", street_address: "123 Main St.", city: "Anytown", state: "NY", country: "USA", gps_longitude: -74.062958, gps_latitude: 40.869911, range: 0.005, configuration_id: 2, api_key: "DEVELOPMENT" )
  Institution.create( name: "Williams", street_address: "880 Main St.", city: "Williamstown", state: "MA", country: "USA", gps_longitude: -73.202887, gps_latitude: 42.710570, range: 0.001, configuration_id: 3, api_key: "WILLIAMS" )
end

# insert dining opportunities for Williams College
def create_williams_dining_opps
  DiningOpportunity.create(dining_opportunity_type: "Breakfast", institution_id: 3)
  DiningOpportunity.create(dining_opportunity_type: "Lunch", institution_id: 3)
  DiningOpportunity.create(dining_opportunity_type: "Dinner", institution_id: 3)
  DiningOpportunity.create(dining_opportunity_type: "Late Night", institution_id: 3)
end

def create_williams_dining_places
  DiningPlace.create(institution_id: 3, name: "Paresky Whitmans Market", range: 0.0002)
  DiningPlace.create(institution_id: 3, name: "Paresky Grab N Go", range: 0.0002)
  DiningPlace.create(institution_id: 3, name: "Faculty House", range: 0.0002)
end

# May also want to seed the configuration files for the database here

def create_dining_opps
  DiningOpportunity.create( dining_opportunity_type: "Breakfast", institution_id: 1 )
  DiningOpportunity.create( dining_opportunity_type: "Lunch", institution_id: 1 )
  DiningOpportunity.create( dining_opportunity_type: "Dinner", institution_id: 1 )
  DiningOpportunity.create( dining_opportunity_type: "Brunch", institution_id: 1 )
  DiningOpportunity.create( dining_opportunity_type: "Late Night", institution_id: 1 )
end


# MenuItems.create( name: nil, institution_id: nil, details_link: nil, small_price: nil, large_price: nil, combo_price: nil, created_at: nil, updated_at: nil, dining_opportunity_id: nil, dining_place_id: nil, date_available: nil, category: nil, serving_size: nil )


def seed_app_dining_periods
  start_hash = {"Breakfast" => 8, "Lunch" => 11, "Dinner" => 16, "Brunch" => 9, "Late Night" => 20}

  DiningOpportunity.all.each { |opp|
    DiningPlace.all.each { |dp|
      (0..6).each { |dow|
        start_hour = start_hash[opp.dining_opportunity_type]
        if ! start_hour.blank?
          DiningPeriod.create(start_time: Time.now.change(hour: start_hour, min: rand(60)), end_time: Time.now.change(hour: start_hour + 3, min: rand(60)), day_of_week: dow, dining_opportunity_id: opp.id, dining_place_id: dp.id, institution_id: 1)
        end
      }
    }
  }
end

def seed_williams_rss_scraping
  ResourceType.create info: "Simple Events", resource_name: "simple_event", model_name: "SimpleEvent"
  ResourceType.create info: "Athletic Events", resource_name: "athletic_event", model_name: "AthleticEvent"
  ResourceType.create info: "Menu Items", resource_name: "menu_item", model_name: "MenuItem"

  ScrapeResource.create url: "https://events.williams.edu/widget/view?schools=williams&days=90&num=100&format=rss", institution_id: 3, validated: true, resource_type_id: 1

  DataResource.create info: "rss feed simple event title", column_name: "title", resource_type_id: 1
  DataResource.create info: "rss feed simple event description", column_name: "event_description", resource_type_id: 1
  DataResource.create info: "rss feed simple event url", column_name: "event_url", resource_type_id: 1

  Selector.create info: "simple event rss title selector", selector: "item", top_level: true, parent_selector_id: nil, data_resource_id: 1, scrape_resource_id: 1
  Selector.create info: "rss events title selector", selector: "title", top_level: false, parent_selector_id: 1, data_resource_id: 1, scrape_resource_id: 1
  Selector.create info: "rss events description selector", selector: "description", top_level: false, parent_selector_id: 1, data_resource_id: 2, scrape_resource_id: 1
  Selector.create info: "simple event rss url selector", selector: "link", top_level: false, parent_selector_id: 1, data_resource_id: 3, scrape_resource_id: 1
end
