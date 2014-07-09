class AddFieldsToMenuItems < ActiveRecord::Migration
  def change
    add_column("menu_items", "category", :string)
    add_column("menu_items", "serving_size", :string)
  end
end
