child :@notification_view do
  attributes :id, :institution_id, :user_id, :activity_log_id, :date_viewed, :viewed, :created_at, :updated_at
end

node(:errors) {@notification_view.errors.full_messages}
