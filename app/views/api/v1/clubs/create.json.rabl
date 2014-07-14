child :@club do
  attributes :id, :institution_id, :club_name, :description, :user_id, :created_at, :updated_at
end

node(:errors) {@club.errors.full_messages}
