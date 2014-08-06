class AddSubscriptionsFieldToDeptsClubsAthleticTeams < ActiveRecord::Migration
  def change
    add_column("departments", :subscriptions, :integer)
    add_column("clubs", :subscriptions, :integer)
    add_column("athletic_teams", :subscriptions, :integer)
  end
end
