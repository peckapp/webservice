collection :@simple_events

attributes(:id, :title, :event_description, :institution_id, :user_id, :department_id, :club_id,
           :circle_id, :event_url, :public, :comment_count, :start_date, :end_date, :created_at,
           :updated_at)

node(:event_type) { 'simple' }

node :image do |simple_event|
  simple_event.image.url
end

node :blurred_image do |simple_event|
  simple_event.image.url(:blurred)
end

node :likes do |simple_event|
  @likes_for_simple_event[simple_event]
end

node :attendees do |simple_event|
  @attendee_ids[simple_event.id]
end
