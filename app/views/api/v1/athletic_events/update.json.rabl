child :@athletic_event do
  attributes :id, :institution_id, :athletic_team_id, :opponent, :team_score, :opponent_score, :home_or_away,:location, :result, :note, :start_date, :created_at, :updated_at
end

node(:errors) {@athletic_event.errors.full_messages}
