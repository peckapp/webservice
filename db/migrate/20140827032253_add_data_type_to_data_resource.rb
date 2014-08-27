class AddDataTypeToDataResource < ActiveRecord::Migration
  def change
    add_column :data_resources, :data_type, :string
  end
end
