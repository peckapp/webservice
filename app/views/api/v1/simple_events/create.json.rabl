child :@simple_event do
  attributes :id, :title, :event_description, :institution_id, :user_id, :category, :organizer_id, :event_url, :public, :comment_count, :start_date, :end_date, :scrape_resource_id, :created_at, :updated_at

  node(:image) { "#{Amazon.base_url}#{@simple_event.image.url}" }

  node(:blurred_image) { "#{Amazon.base_url}#{@simple_event.image.url(:blurred)}" }
end

node(:errors) { @simple_event.errors.full_messages }
