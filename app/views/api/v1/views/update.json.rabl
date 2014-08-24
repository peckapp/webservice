child :@view do
  attributes :id, :institution_id, :user_id, :category, :content_id, :date_viewed, :created_at, :updated_at
end

node(:errors) {@view.errors.full_messages}
