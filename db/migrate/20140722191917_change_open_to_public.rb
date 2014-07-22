class ChangeOpenToPublic < ActiveRecord::Migration
  def change
    rename_column :simple_events, :open, :public
  end
end
