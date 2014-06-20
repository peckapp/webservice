class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|
      t.integer "institution_id", :null => false
      t.string "mascot"
      t.string "config_file_name", :null => false

      t.timestamps
    end
    add_index("configurations", "institution_id")
  end
end
