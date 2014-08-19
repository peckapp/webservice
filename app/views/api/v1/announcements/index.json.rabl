collection :@announcements
  attributes :id, :title, :announcement_description, :institution_id, :user_id, :department_id, :club_id, :circle_id, :public, :comment_count, :created_at, :updated_at

node :image do |announcement|
  "#{Amazon.base_url}#{announcement.image.url}"
end

node :likes do |announcement|
  @likes_for_announcement[announcement]
end
