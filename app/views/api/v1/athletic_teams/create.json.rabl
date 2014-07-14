child :@athletic_team do
  attributes :id, :institution_id, :sport_name, :gender, :head_coach, :team_link, :created_at, :updated_at
end

node(:errors) {@athletic_team.errors.full_messages}
