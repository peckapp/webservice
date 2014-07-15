class CreateSelectors < ActiveRecord::Migration

  def change
    create_table :selectors do |t|
      # general info string, useful for debugging this system
      t.string :info
      # string for the selector that relates to this property
      t.string :selector, null: false
      # whether or not this is a top-level selector that contains all the information for a model
      t.boolean :top_level, default: false
      # for nested selectors
      t.integer :parent_selector_id
      t.integer :data_resource_id, null: false
      t.integer :scrape_resource_id, null: false

      t.timestamps
    end
  end
end
