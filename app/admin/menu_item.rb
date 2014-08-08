ActiveAdmin.register MenuItem do

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name, :institution_id, :details_link, :small_price, :large_price, :combo_price, :created_at,
                :dining_opportunity_id, :dining_place_id, :date_available, :category, :serving_size, :scrape_resource_id

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
    id_column
    column :name
    column :category
    column :date_available
    column :institution
    column :dining_opportunity
    column :dining_place
    column :scrape_resource
    column :created_at
    column :updated_at
    actions
  end

end
