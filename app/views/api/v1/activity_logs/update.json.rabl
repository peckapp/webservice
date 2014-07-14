child :@activity_log do
  attributes :id, :institution_id, :sender, :receiver, :category, :from_event, :circle_id, :type_of_activity,:message, :read_status, :created_at, :updated_at
end

node(:errors) {@activity_log.errors.full_messages}
