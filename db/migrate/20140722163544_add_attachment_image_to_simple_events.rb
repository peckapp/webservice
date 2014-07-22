class AddAttachmentImageToSimpleEvents < ActiveRecord::Migration
  def self.up
    change_table :simple_events do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :simple_events, :image
  end
end
