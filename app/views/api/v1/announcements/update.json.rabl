child :@announcement do
  attributes :id, :title, :announcement_description, :institution_id, :user_id, :category, :poster_id, :public, :comment_count, :created_at, :updated_at

  node(:image) {@announcement.image.url}
end

node(:errors) {@announcement.errors.full_messages}
