ActiveAdmin.register DiningPlace do

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  # Adds this into a dropdown in the top menu bar
  menu parent: 'Dining'

  index do
    selectable_column
    id_column
    column :name
    column :institution
    column :details_link
    column :gps_longitude
    column :gps_latitude
    column :range
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :institution
      row :details_link
      row :gps_longitude
      row :gps_latitude
      row :range
      row :image do
        image_tag(dining_place.image.url(:detail))
      end
      row :created_at
      row :updated_at
    end
  end

end
