class CreateDataResources < ActiveRecord::Migration
  def change
    create_table :data_resources do |t|
      t.info :string
      t.column_name :string
      t.resource_type_id :integer

      t.timestamps
    end
  end
end
