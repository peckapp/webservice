object :@athletic_event

attributes :id, :institution_id, :athletic_team_id, :opponent, :team_score, :opponent_score, :home_or_away,
           :location, :result, :note, :start_time, :end_time, :title, :description, :created_at, :updated_at

node(:event_type) { 'athletic' }

node :image do
  @athletic_event.image.url
end

node :blurred_image do
  @athletic_event.image.url(:blurred)
end

# node :likes do |athletic_event|
#   @likes_for_simple_event[@athletic_event.id]
# end

node :attendees do
  @attendee_ids[@athletic_event.id]
end
