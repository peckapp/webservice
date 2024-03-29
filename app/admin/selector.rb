ActiveAdmin.register Selector do
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :info, :selector, :top_level, :parent_id, :data_resource_id, :foreign_data_resource_id,
                :scrape_resource_id, :content_type
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  # Adds this into a dropdown in the top menu bar
  menu parent: 'Scraping', priority: 5

  active_admin_importable

  index do
    selectable_column
    id_column
    column :info
    column :selector
    column :top_level
    column :parent
    column :content_type
    column :data_resource
    column :foreign_data_resource
    column :scrape_resource
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do # builds an input field for specified attributes
      row :info
      row :selector
      row :top_level
      row :parent
      row :content_type
      row :scrape_resource
      row :data_resource
      row :foreign_data_resource
    end
    ### TODO: DOESNT CURRENTLY WORK, NEED TO FIGURE OUT HOW TO GET CHILDREN IN ATTRIBUTES TABLE
    panel 'Children' do # builds an input field for specified attributes
      selector.children.each do |_cs|
        attributes_table do
          row :info
          row :selector
          row :top_level
          row :scrape_resource
          row :data_resource
        end
      end
    end
  end

  # creates a form for a new resource
  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do # builds an input field for specified attributes
      f.input :info
      f.input :selector
      f.input :top_level, as: :radio, label: 'Top Level Selector'
      # showing all
      f.input :parent, as: :select, label: 'Parent Selector',
                       collection: Hash[Selector.all.map { |s| ["#{s.top_level ? 'TL ' : '-> ' } #{s.info}: #{s.selector}", s.id] }]
      f.input :content_type, as: :select,
                             collection: Hash[Selector::TYPES.map { |t| [t, t] }]
      f.input :scrape_resource, as: :select,
                                collection: Hash[ScrapeResource.all.map { |sr| ["#{sr.info} => #{sr.url}", sr.id] }]
      f.input :data_resource, as: :select,
                              collection: Hash[DataResource.all.map { |dr| ["#{dr.info} => #{dr.column_name}", dr.id] }]
      f.input :foreign_data_resource, collection: Hash[DataResource.where(foreign_key: false).map { |dr| ["#{dr.info} => #{dr.column_name}", dr.id] }]
    end
    f.inputs 'Children' do # builds an input field for specified attributes
      f.has_many :children do |j|
        j.input :info
        j.input :selector
        j.input :top_level, label: 'Top Level Selector'
        j.input :scrape_resource, as: :select, collection: Hash[ScrapeResource.all.map { |sr| ["#{sr.info} => #{sr.url}", sr.id] }]
        j.input :data_resource, as: :select, collection: Hash[DataResource.all.map { |dr| ["#{dr.info} => #{dr.column_name}", dr.id] }]
      end
    end
    f.actions # adds the 'Submit' and 'Cancel' buttons
  end

end
