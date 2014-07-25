child :@user do
  attributes :id, :institution_id, :api_key, :created_at, :updated_at

  node(:new_user) {@user.newly_created_user}
  node(:image) {@user.image.url}
end

node(:errors) {@user.errors.full_messages}
