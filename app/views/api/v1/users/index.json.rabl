collection :@users

attributes :id, :institution_id, :first_name, :last_name, :email, :blurb, :facebook_link, :active, :created_at, :updated_at

node :image do |user|
  "#{Amazon.base_url}#{user.image.url}"
end

node :thumb_image do |user|
  "#{Amazon.base_url}#{user.image.url(:thumb)}"
end
