class ChangeEventCommentsToComments < ActiveRecord::Migration
  def change
    rename_table("event_comments", "comments")
  end
end
