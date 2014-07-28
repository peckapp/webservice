object :@comment

attributes :id, :institution_id, :category, :comment_from, :user_id, :content, :created_at, :updated_at

node(:likes) {@likes.blank? ? nil : @likes}
