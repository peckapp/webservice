child :@event_view do
  attributes :id, :institution_id, :user_id, :category, :event_viewed, :date_viewed, :created_at, :updated_at
end

node(:errors) {@event_view.errors.full_messages}
