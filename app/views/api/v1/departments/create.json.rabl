child :@department do
  attributes :id, :name, :institution_id, :created_at, :updated_at
end

node(:errors) {@department.errors.full_messages}
