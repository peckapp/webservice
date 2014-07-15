child :@user do
  attributes :id, :institution_id, :api_key, :created_at, :updated_at
end

node(:errors) {@user.errors.full_messages}
