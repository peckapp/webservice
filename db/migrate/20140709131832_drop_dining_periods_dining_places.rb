class DropDiningPeriodsDiningPlaces < ActiveRecord::Migration
  def up
    drop_table :dining_periods_dining_places
  end

  def down
    create_table "dining_periods_dining_places", id: false do |t|
      t.integer "dining_period_id", null: false
      t.integer "dining_place_id",  null: false
    end
    add_index "dining_periods_dining_places", ["dining_period_id", "dining_place_id"], name: "dining_periods_dining_places_index"
  end
end
