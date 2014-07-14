child :@comment do
  attributes :id, :institution_id, :category, :comment_from, :user_id, :content, :created_at, :updated_at
end

node(:errors) {@comment.errors.full_messages}
