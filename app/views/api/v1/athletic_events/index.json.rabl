collection :@athletic_events

attributes :id, :institution_id, :athletic_team_id, :opponent, :team_score, :opponent_score, :home_or_away,
           :location, :result, :note, :date_and_time, :title, :description, :created_at, :updated_at

node(:event_type) { 'athletic' }
