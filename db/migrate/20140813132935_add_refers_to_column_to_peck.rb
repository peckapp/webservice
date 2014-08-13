class AddRefersToColumnToPeck < ActiveRecord::Migration
  def up
    add_column :pecks, :refers_to, :integer
  end

  def down
    remove_column :pecks, :refers_to
  end
end
