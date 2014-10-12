class AddAttachmentImageToDiningPlaces < ActiveRecord::Migration
  def self.up
    change_table :dining_places do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :dining_places, :image
  end
end
