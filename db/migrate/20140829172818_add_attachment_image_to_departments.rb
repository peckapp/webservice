class AddAttachmentImageToDepartments < ActiveRecord::Migration
  def self.up
    change_table :departments do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :departments, :image
  end
end
