class AddDefaultToSubscriberCount < ActiveRecord::Migration
  def change
    remove_column(:departments, :subscriber_count)
    remove_column(:clubs,  :subscriber_count)
    remove_column(:athletic_teams,  :subscriber_count)
    add_column(:departments, :subscriber_count, :integer, default: 0)
    add_column(:clubs, :subscriber_count, :integer, default: 0)
    add_column(:athletic_teams, :subscriber_count, :integer, default: 0)
  end
end
