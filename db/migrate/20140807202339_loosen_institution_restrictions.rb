class LoosenInstitutionRestrictions < ActiveRecord::Migration
  def change
    change_column :institutions, :street_address, :string, null: true
    change_column :institutions, :gps_longitude, :integer, null: true
    change_column :institutions, :gps_latitude, :integer, null: true
    change_column :institutions, :range, :integer, null: true
    change_column :institutions, :configuration_id, :string, null: true
    change_column :institutions, :api_key, :string, null: true

    add_column :configurations, :institution_id, :integer
  end
end
