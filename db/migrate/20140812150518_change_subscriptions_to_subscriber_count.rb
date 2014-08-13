class ChangeSubscriptionsToSubscriberCount < ActiveRecord::Migration
  def change
    rename_column(:departments, :subscriptions, :subscriber_count)
    rename_column(:clubs, :subscriptions, :subscriber_count)
    rename_column(:athletic_teams, :subscriptions, :subscriber_count)
  end
end
