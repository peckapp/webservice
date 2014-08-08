class LoosenInstitutionRestrictions < ActiveRecord::Migration
  def up
    change_column :institutions, :street_address, :string, null: true
    change_column :institutions, :gps_longitude, :float, null: true
    change_column :institutions, :gps_latitude, :float, null: true
    change_column :institutions, :range, :float, null: true
    change_column :institutions, :configuration_id, :integer, null: true
    change_column :institutions, :api_key, :string, null: true

    add_column :configurations, :institution_id, :integer
  end

  def down
    change_column :institutions, :street_address, :string, null: false
    change_column :institutions, :gps_longitude, :float, null: false
    change_column :institutions, :gps_latitude, :float, null: false
    change_column :institutions, :range, :float, null: false
    change_column :institutions, :configuration_id, :integer, null: false
    change_column :institutions, :api_key, :string, null: false

    remove_column :configurations, :institution_id, :integer
  end
end
