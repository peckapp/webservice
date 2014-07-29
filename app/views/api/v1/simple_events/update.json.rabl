child :@simple_event do
  attributes :id, :title, :event_description, :institution_id, :user_id, :department_id, :club_id, :circle_id, :event_url, :public, :comment_count, :start_date, :end_date, :created_at, :updated_at, :image

  node(:image) { @simple_event.image.url }

  node(:blurred_image) { @simple_event.image.url(:blurred) }
end

node(:errors) { @simple_event.errors.full_messages }
