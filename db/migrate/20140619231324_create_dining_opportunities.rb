class CreateDiningOpportunities < ActiveRecord::Migration
  def change
    create_table :dining_opportunities do |t|
      t.string "type", :null => false # i.e. breakfast, lunch, or dinner
      t.integer "institution_id", :null => false

      t.timestamps
    end
    add_index("dining_opportunities", "type")
    add_index("dining_opportunities", "institution_id")
  end
end
