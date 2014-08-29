class AddAttachmentImageToAthleticTeams < ActiveRecord::Migration
  def self.up
    change_table :athletic_teams do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :athletic_teams, :image
  end
end
