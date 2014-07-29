class AddStatusToCircleMembers < ActiveRecord::Migration
  def change
    add_column "circle_members", "accepted", :boolean, :default => false
  end
end
