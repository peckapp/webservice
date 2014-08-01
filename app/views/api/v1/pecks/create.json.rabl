child :@peck do
  attributes :id, :user_id, :institution_id, :notification_type, :message, :send_push_notification, :invited_by, :invitation, :created_at, :updated_at
end

node(:errors) {@peck.errors.full_messages}
