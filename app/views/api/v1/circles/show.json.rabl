object :@circle

attributes :id, :institution_id, :user_id, :circle_name, :image_link, :created_at, :updated_at

node(:circle_members) {@member_ids}
