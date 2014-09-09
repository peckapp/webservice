collection :@clubs

attributes :id, :institution_id, :club_name, :description, :user_id, :created_at, :updated_at

node :image do |club|
  club.image.url(:home)
end
