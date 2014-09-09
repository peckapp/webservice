collection :@athletic_teams

attributes :id, :institution_id, :sport_name, :gender, :head_coach, :team_link, :created_at, :updated_at

node :image do |athletic_team|
  athletic_team.image.url(:home)
end
