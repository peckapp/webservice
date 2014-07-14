child :@user do
  attributes :id, :institution_id, :created_at, :updated_at
end

node(:errors) {@user.errors.full_messages}
