class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|
      t.string "mascot"
      t.string "config_file_name", :null => false

      t.timestamps
    end
  end
end
