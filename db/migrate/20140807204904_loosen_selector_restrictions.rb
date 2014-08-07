class LoosenSelectorRestrictions < ActiveRecord::Migration
  def up
    change_column :selectors, :data_resource_id, :integer, null: true
  end

  def down
    change_column :selectors, :data_resource_id, :integer, null: false
  end
end
