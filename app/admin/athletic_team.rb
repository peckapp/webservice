ActiveAdmin.register AthleticTeam do


  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  # Adds this into a dropdown in the top menu bar
  menu parent: 'Institutional'

  index do
    selectable_column
    id_column
    column :sport_name
    column :gender
    column :institution
    column :head_coach
    column :team_link
    column :simple_name
    column :subscriber_count
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :sport_name
      row :gender
      row :institution
      row :head_coach
      row :team_link
      row :subscriber_count
      row :simple_name
      row :image_file_name
      row :image_url do
        athletic_team.image.url
      end
      row :image do
        image_tag(athletic_team.image.url(:detail))
      end
      row :created_at
      row :updated_at
    end
  end

end
