collection :@circles

attributes :id, :institution_id, :user_id, :circle_name, :created_at, :updated_at

node :circle_members do |circ|
  @member_ids[circ.id]
end
