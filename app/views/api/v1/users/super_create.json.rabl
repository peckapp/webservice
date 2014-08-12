child :@user do
  attributes :id, :institution_id, :first_name, :last_name, :email, :blurb, :facebook_link, :active, :created_at, :updated_at, :authentication_token, :image, :active

  node(:image) { @user.image.url }
  node(:thumb_image) { @user.image.url(:thumb) }
end

node(:errors) { @user.errors.full_messages }
