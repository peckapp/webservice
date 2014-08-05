ActiveAdmin.register ResourceType do


  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :info, :resource_name, :model_name
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  # Adds this into a dropdown in the top menu bar
  menu parent: 'Scraping', priority: 1

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs 'Details' do # builds an input field for every attribute
      f.input :resource_name
      f.input :info
      # all model names that are neither HABTM relationships or nested modules with '::' in their name
      models = ActiveRecord::Base.descendants.select { |d| !d.name.match(/HABTM|::/) }.sort_by { |m| m.name }
      f.input :model_name, collection: models
    end
    f.actions # adds the 'Submit' and 'Cancel' buttons
  end

end
