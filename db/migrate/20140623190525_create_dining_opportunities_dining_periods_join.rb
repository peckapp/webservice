class CreateDiningOpportunitiesDiningPeriodsJoin < ActiveRecord::Migration
  def change
    create_table :dining_opportunities_dining_periods, :id => false do |t|
      t.integer "dining_opportunity_id", :null => false
      t.integer "dining_period_id", :null => false
    end
    add_index("dining_opportunities_dining_periods", ["dining_opportunity_id", "dining_period_id"], :name => "dining_opportunities_dining_periods_index")
  end
end
