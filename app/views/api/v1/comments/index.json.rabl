collection :@comments

attributes :id, :institution_id, :category, :comment_from, :user_id, :content, :created_at, :updated_at

node :likes do |comment|
  @likes_for_comment[comment]
end
