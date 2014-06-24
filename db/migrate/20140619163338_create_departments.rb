class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string "name", :null => false
      t.integer "institution_id", :null => false

      t.timestamps
    end
    add_index("departments", "name")
    add_index("departments", "institution_id")
  end
end
