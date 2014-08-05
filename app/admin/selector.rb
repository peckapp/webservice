ActiveAdmin.register Selector do
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :info, :selector, :top_level, :parent_selector_id, :data_resource_id, :scrape_resource_id
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  # Adds this into a dropdown in the top menu bar
  menu parent: 'Scraping'

  # creates a form for a new resource
  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs 'Parameters' do # builds an input field for specified attributes
      f.input :info
      f.input :selector
      f.input :top_level, as: :radio, label: 'Top Level Selector'
      f.input :parent, as: :select, label: 'Parent Selector', collection: Hash[Selector.where(top_level: true).map { |s| ["#{s.info}: #{s.selector}", s.id] }]
      f.input :scrape_resource, as: :select, collection: Hash[ScrapeResource.all.map { |sr| ["#{sr.info} => #{sr.url}", sr.id] }]
      f.input :data_resource, as: :select, collection: Hash[DataResource.all.map { |dr| ["#{dr.info} => #{dr.column_name}", dr.id] }]
    end
    f.actions # adds the 'Submit' and 'Cancel' buttons
  end

  index do
    id_column
    column :info
    column :selector
    column :top_level
    column :parent
    column :created_at
    column :updated_at
    actions
  end

end
