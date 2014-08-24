class AddTitleAndDescriptionToAthleticEvents < ActiveRecord::Migration
  def change
    add_column :athletic_events, :title, :string
    add_column :athletic_events, :description, :string
  end
end
