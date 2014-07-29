child :@user do
  attributes :id, :institution_id, :api_key, :created_at, :updated_at

  node(:image) { @user.image.url }
  node(:thumb_image) { @user.image.url(:thumb) }
end

node(:errors) { @user.errors.full_messages }
