class RemoveNonPaperclipImageUrLs < ActiveRecord::Migration
  def up
    remove_column :circles, :image_link
    remove_column :simple_events, :image_url
  end

  def down
    add_column :simple_events, :image_url, :string
    add_column :circles, :image_link, :string
  end
end
