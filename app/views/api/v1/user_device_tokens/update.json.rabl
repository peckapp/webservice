child :@user_device_token do
  attributes :id, :token, :created_at, :updated_at
end

node(:errors) {@user_device_token.errors.full_messages}
