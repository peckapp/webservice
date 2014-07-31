child :@user do
  attributes :id, :institution_id, :first_name, :last_name, :email, :blurb, :facebook_link,  :active, :created_at, :updated_at, :image, :api_key

  node(:new_user) { @user.newly_created_user }
  node(:image) { @user.image.url }
  node(:thumb_image) { @user.image.url(:thumb) }
end

node(:errors) { @user.errors.full_messages }
