child :@user do
  attributes :id, :institution_id, :first_name, :last_name, :username, :blurb, :facebook_link, :active, :created_at, :updated_at
end

node(:errors) {@user.errors.full_messages}
