collection :@circle_members

attributes :id, :circle_id, :user_id, :invited_by, :date_added, :created_at, :updated_at

node(:circle_members_for_specific_circle) { |circle_member| circle_member.where(:circle_id => params[:circle_id]) }
