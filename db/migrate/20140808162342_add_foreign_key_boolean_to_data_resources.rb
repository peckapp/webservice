class AddForeignKeyBooleanToDataResources < ActiveRecord::Migration
  def change
    add_column :data_resources, :foreign_key, :boolean
  end
end
