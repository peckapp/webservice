child :@circle do
  attributes :id, :institution_id, :user_id, :circle_name, :image_link, :created_at, :updated_at
end

node(:circle_members) {@member_ids}

node(:errors) {@circle.errors.full_messages}
