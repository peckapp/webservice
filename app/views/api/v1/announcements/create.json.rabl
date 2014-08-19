child :@announcement do
  attributes :id, :title, :announcement_description, :institution_id, :user_id, :department_id, :club_id, :circle_id, :public, :comment_count, :created_at, :updated_at

  node(:image) {"#{Amazon.base_url}#{@announcement.image.url}"}
end

node(:errors) {@announcement.errors.full_messages}
