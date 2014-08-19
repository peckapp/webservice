class ChangeAnnouncementColumns < ActiveRecord::Migration
  def up
    remove_column(:announcements, :department_id)
    remove_column(:announcements, :club_id)
    remove_column(:announcements, :circle_id)
    add_column(:announcements, :category, :string)
    add_column(:announcements, :poster_id, :integer)
  end

  def down
    remove_column(:announcements, :poster)
    remove_column(:announcements, :category)
    add_column(:announcements, :circle_id, :integer)
    add_column(:announcements, :club_id, :integer)
    add_column(:announcements, :department_id, :integer)
  end
end
