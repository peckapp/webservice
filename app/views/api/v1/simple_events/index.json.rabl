collection :@simple_events

attributes(:id, :title, :event_description, :institution_id, :user_id, :category, :organizer_id, :event_url, :public, :comment_count, :start_date, :end_date, :scrape_resource_id, :created_at,
           :updated_at)

node(:event_type) { 'simple' }

node :image do |simple_event|
  "#{Amazon.base_url}#{simple_event.image.url}"
end

node :blurred_image do |simple_event|
  "#{Amazon.base_url}#{simple_event.image.url(:blurred)}"
end

node :likes do |simple_event|
  @likes_for_simple_event[simple_event.id]
end

node :attendees do |simple_event|
  @attendee_ids[simple_event.id]
end
