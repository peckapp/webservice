child :@circle do
  attributes :id, :institution_id, :user_id, :circle_name, :image_link, :created_at, :updated_at
end

node(:errors) {@circle.errors.full_messages}
