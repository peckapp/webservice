ActiveAdmin.register DiningOpportunity do

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
    column :dining_opportunity_type
    column :institution
    column :created_at
    column :updated_at
    actions
  end

end
