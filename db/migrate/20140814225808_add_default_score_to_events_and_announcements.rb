class AddDefaultScoreToEventsAndAnnouncements < ActiveRecord::Migration
  def change
    add_column(:simple_events, :default_score, :integer, default: 0)
    add_column(:athletic_events, :default_score, :integer, default: 0)
    add_column(:announcements, :default_score, :integer, default: 0)
  end
end
