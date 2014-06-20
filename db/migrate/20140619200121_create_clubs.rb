class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.integer "institution_id", :null => false
      t.string "club_name", :null => false
      t.text "description"
      t.integer "user_id" # links to users table. Admin
      t.timestamps
    end
    add_index("clubs", "institution_id")
    add_index("clubs", "club_name")
    add_index("clubs", "user_id")
  end
end
