collection :@athletic_events

attributes :id, :institution_id, :athletic_team_id, :opponent, :team_score, :opponent_score, :home_or_away,
           :location, :result, :note, :start_time, :end_time, :title, :description, :created_at, :updated_at

node(:event_type) { 'athletic' }

node :team_name do |athletic_event|
  # gives the simple name which includes the gender
  @team_names_for_ids[athletic_event.id]
end

node :image do |athletic_event|
  if athletic_event.image.url.match(/missing/)
    @team_images_for_ids[athletic_event.id].url(:home)
  else
    athletic_event.image.url(:home)
  end
end

node :blurred_image do |athletic_event|
  if athletic_event.image.url.match(/missing/)
    @team_images_for_ids[athletic_event.id].url(:blurred)
  else
    athletic_event.image.url(:blurred)
  end
end

node :likes do |athletic_event|
  @likes_for_athletic_event[athletic_event.id]
end

node :attendees do |athletic_event|
  @attendee_ids[athletic_event.id]
end
