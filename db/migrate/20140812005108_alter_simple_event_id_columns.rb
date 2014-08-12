class AlterSimpleEventIdColumns < ActiveRecord::Migration
  def up
    remove_column(:simple_events, :department_id)
    remove_column(:simple_events, :club_id)
    remove_column(:simple_events, :circle_id)
    add_column(:simple_events, :category, :string)
    add_column(:simple_events, :organizer_id, :integer)
  end

  def down
    remove_column(:simple_events, :organizer_id)
    remove_column(:simple_events, :category)
    add_column(:simple_events, :circle_id, :integer)
    add_column(:simple_events, :club_id, :integer)
    add_column(:simple_events, :department_id, :integer)
  end
end
