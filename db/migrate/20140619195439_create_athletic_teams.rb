class CreateAthleticTeams < ActiveRecord::Migration
  def change
    create_table :athletic_teams do |t|
      t.integer "institution_id", :null => false
      t.string "sport_name", :null => false
      t.string "gender", :null => false
      t.string "head_coach"
      t.string "team_link" #URL for deatils of the team
      t.timestamps
    end
    add_index("athletic_teams", "institution_id" )
    add_index("athletic_teams", "sport_name")
    add_index("athletic_teams", "gender")
  end
end
