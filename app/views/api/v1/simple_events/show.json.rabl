object :@simple_event

attributes(:id, :title, :event_description, :institution_id, :user_id, :category, :organizer_id, :url, :public, :comment_count, :start_date, :scrape_resource_id, :end_date, :created_at,
           :updated_at, :image)

node(:event_type) { 'simple' }

node(:image) { @simple_event.image.url }

node(:blurred_image) { @simple_event.image.url(:blurred) }

node(:likes) { @likes.blank? ? nil : @likes }

node(:attendees) { @attendee_ids }
