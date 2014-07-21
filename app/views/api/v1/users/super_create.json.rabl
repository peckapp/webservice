child :@user do
  attributes :id, :institution_id, :first_name, :last_name, :email, :blurb, :facebook_link, :active, :created_at, :updated_at, :authentication_token
end

node(:errors) {@user.errors.full_messages}
