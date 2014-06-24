class CreateAthleticEvents < ActiveRecord::Migration
  def change
    create_table :athletic_events do |t|
      t.integer "institution_id", :null => false #links to institutions table
      t.integer "athletic_team_id", :null => false # links to athletic_teams table
      t.string "opponent"
      t.float "team_score"
      t.float "opponent_score"
      t.string "home_or_away"
      t.string "location", :null => false
      t.string "result" # i.e. position, score, etc
      t.text "note" # other information about event
      # t.string "creator",    creater of the event
      t.datetime "date_and_time"

      t.timestamps
    end
    add_index("athletic_events", "institution_id")
    add_index("athletic_events", "athletic_team_id")
    add_index("athletic_events", "opponent")
    add_index("athletic_events", "location")
    add_index("athletic_events", "date_and_time")
  end
end
