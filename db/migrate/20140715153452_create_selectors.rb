class CreateSelectors < ActiveRecord::Migration

  def change
    create_table :selectors do |t|
      # general info string, useful for debugging this system
      t.info :string
      # string for the selector that relates to this property
      t.selector :string
      # whether or not this is a top-level selector that contains all the information for a model
      t.top_level :boolean
      # for nested selectors
      t.parent_selector_id :integer
      t.data_resource_id :integer
      t.scrape_resource_id :integer

      t.timestamps
    end
  end
end
