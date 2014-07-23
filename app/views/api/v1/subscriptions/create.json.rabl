child :@subscriptions do
  attributes :id, :institution_id, :user_id, :category, :subscribed_to, :created_at, :updated_at
end

node :errors do |subscription|
  subscription.errors.full_messages
end
