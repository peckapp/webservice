child :@user do
  attributes :id, :institution_id, :api_key, :created_at, :updated_at

  node(:image) {@user.image.url}
end

node(:errors) {@user.errors.full_messages}
