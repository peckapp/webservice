class CreateResourceTypes < ActiveRecord::Migration
  def change
    create_table :resource_types do |t|
      t.resource_name :string,       null: false
      t.scrape_resource_id :integer, null: false

      t.timestamps
    end
  end
end
