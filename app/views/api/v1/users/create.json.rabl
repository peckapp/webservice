child :@user do
  attributes :id, :institution_id, :api_key, :active, :created_at, :updated_at

  node(:image) { "#{Amazon.base_url}#{@user.image.url}" }
  node(:thumb_image) { "#{Amazon.base_url}#{@user.image.url(:thumb)}" }
end

node(:errors) { @user.errors.full_messages }
