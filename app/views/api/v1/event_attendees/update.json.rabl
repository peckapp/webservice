child :@event_attendee do
  attributes :id, :institution_id, :user_id, :added_by, :category, :event_attended, :created_at, :updated_at
end

node(:errors) {@event_attendee.errors.full_messages}
