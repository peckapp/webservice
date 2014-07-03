class CreateDiningOpportunitiesDiningPlacesJoin < ActiveRecord::Migration
  def change
    create_table :dining_opportunities_dining_places, :id => false do |t|
      t.integer "dining_opportunity_id", :null => false
      t.integer "dining_place_id", :null => false
    end
    add_index("dining_opportunities_dining_places", ["dining_opportunity_id", "dining_place_id"], :name => "dining_opportunities_dining_places_index")
  end
end
