class CreateDataResources < ActiveRecord::Migration
  def change
    create_table :data_resources do |t|
      t.string :info
      # name of the column within the model that the selectors for this DataResource relate to
      t.string :column_name,       null: false
      # id of the associated resource type indicating the model for this DataResource
      t.integer :resource_type_id, null:false

      t.timestamps
    end
  end
end
