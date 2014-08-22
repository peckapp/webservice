class AddForeignDataResourceToSelectors < ActiveRecord::Migration
  def change
    add_column :selectors, :foreign_data_resource_id, :integer
  end
end
