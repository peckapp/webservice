child :@push_notification do
  attributes :id, :user_id, :institution_id, :notification_type, :response, :created_at, :updated_at
end

node(:errors) {@push_notification.errors.full_messages}
