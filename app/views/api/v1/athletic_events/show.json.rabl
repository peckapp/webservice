object :@athletic_event

attributes :id, :institution_id, :athletic_team_id, :opponent, :team_score, :opponent_score, :home_or_away,:location, :result, :note, :start_time, :created_at, :updated_at

node(:event_type) {"athletic"} 
