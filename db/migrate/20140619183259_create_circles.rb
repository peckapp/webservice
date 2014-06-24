class CreateCircles < ActiveRecord::Migration
  def change
    create_table :circles do |t|
      t.integer "institution_id", :null => false # links to institutions table
      t.integer "user_id", :null => false # links to users table. Author
      t.string "circle_name", :null => false
      t.string "image_link"
      # t.boolean "public", :null => false     is the circle viewable by everyone?

      t.timestamps
    end
    add_index("circles", "institution_id")
    add_index("circles", "user_id")
    add_index("circles", "circle_name")
  end
end
