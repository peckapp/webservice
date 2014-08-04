collection :@all_pecks
  attributes :id, :user_id, :institution_id, :notification_type, :message, :send_push_notification, :invited_by, :interacted, :invitation, :created_at, :updated_at

node(:device_tokens) {@peck_dict}

node :errors do |peck|
   peck.errors.full_messages
 end
