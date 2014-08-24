class AddAttachmentImageToAthleticEvents < ActiveRecord::Migration
  def self.up
    change_table :athletic_events do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :athletic_events, :image
  end
end
