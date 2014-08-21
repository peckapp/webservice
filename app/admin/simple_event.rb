ActiveAdmin.register SimpleEvent do

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
  menu parent: 'Content'

  index do
    selectable_column
    id_column
    column :title
    column :event_description
    column :location
    column :institution
    column :user
    column :public
    column :start_date
    column :end_date
    column :deleted
    column :longitude
    column :latitude
    column :category
    column :default_score
    column :created_at
    column :updated_at
    actions
  end

end
