class AddLocationsToSimpleEvents < ActiveRecord::Migration
  def change
    add_column :simple_events, :latitude, :float
    add_column :simple_events, :longitude, :float
  end
end
