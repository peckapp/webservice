class AddColumnsToPecks < ActiveRecord::Migration
  def up
    add_column "pecks", "invitation", :integer
  end

  def down
    remove_column "pecks", "invitation"
  end
end
