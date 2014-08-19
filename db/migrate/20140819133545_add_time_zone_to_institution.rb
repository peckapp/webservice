class AddTimeZoneToInstitution < ActiveRecord::Migration
  def up
    add_column :institutions, :time_zone, :string
  end

  def down
    remove_column :institutions, :time_zone
  end
end
