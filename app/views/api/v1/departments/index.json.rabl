collection :@departments

attributes :id, :name, :institution_id, :created_at, :updated_at

node :image do |department|
  department.image.url(:home)
end
