collection :@announcements
  attributes :id, :title, :announcement_description, :institution_id, :user_id, :category, :poster_id, :public, :comment_count, :created_at, :updated_at

node :image do |announcement|
  announcement.image.url
end

node :likes do |announcement|
  @likes_for_announcement[announcement]
end
