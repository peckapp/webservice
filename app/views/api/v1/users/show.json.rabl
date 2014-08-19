object :@user

attributes :id, :institution_id, :first_name, :last_name, :email, :blurb, :facebook_link,  :active, :created_at, :updated_at, :image

node(:image) { "#{Amazon.base_url}#{@user.image.url}" }

node(:thumb_image) { "#{Amazon.base_url}#{@user.image.url(:thumb)}" }
