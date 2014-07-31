child :@circle_member do
  attributes :id, :institution_id, :circle_id, :user_id, :invited_by, :date_added, :accepted, :created_at, :updated_at
end

node(:errors) {@circle_member.errors.full_messages}
