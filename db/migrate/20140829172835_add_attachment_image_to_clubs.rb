class AddAttachmentImageToClubs < ActiveRecord::Migration
  def self.up
    change_table :clubs do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :clubs, :image
  end
end
