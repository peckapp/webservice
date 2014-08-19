collection :@users

attributes :id, :institution_id, :first_name, :last_name, :email, :blurb, :facebook_link, :active, :created_at, :updated_at

node :image do |user|
  user.image.url
end

node :thumb_image do |user|
  user.image.url(:thumb)
end
