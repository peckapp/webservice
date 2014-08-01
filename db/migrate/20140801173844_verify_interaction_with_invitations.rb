class VerifyInteractionWithInvitations < ActiveRecord::Migration
  def up
    add_column "pecks", "interacted", :boolean, :default => false
  end

  def down
    remove_column "pecks", "interacted"
  end
end
