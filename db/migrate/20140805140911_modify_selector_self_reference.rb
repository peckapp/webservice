class ModifySelectorSelfReference < ActiveRecord::Migration
  def change
    rename_column :selectors, :parent_selector_id, :parent_id
  end
end
