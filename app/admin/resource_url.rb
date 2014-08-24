ActiveAdmin.register ResourceUrl do


  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :scrape_resource, :url, :info, :validated, :ecraped_value
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  # Adds this into a dropdown in the top menu bar
  menu parent: 'Scraping', priority: 3

  index do
    selectable_column
    id_column
    column :scrape_resource
    column :url
    column :validated
    column :scraped_value
    column :info
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs 'Details' do
      f.input :scrape_resource
      f.input :url
      f.input :validated, as: :radio
      f.input :scraped_value
      f.input :info
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

end
