class AddLocationToSimpleEvents < ActiveRecord::Migration
  def change
    add_column :simple_events, :location, :string
  end
end
