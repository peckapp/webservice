ActiveAdmin.register ScrapeResource do

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :url, :institution_id, :scrape_interval, :validated, :resource_type_id, :pagination_selector_id,
                :info, :kind, :engine_type
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  # Adds this into a dropdown in the top menu bar
  menu parent: 'Scraping', priority: 2

  # sidebar 'ResourceUrls', only: :show do
  #   table_for scrape_resource.resource_urls do |ru|
  #     t.column('Url') { |ru| ru.url }
  #     t.column('Scraped Value') { |ru| ru.scraped_value }
  #   end
  # end

  active_admin_importable do |model, hash|
    # delete things that are unique to a specific database
    hash.delete(:id)
    hash.delete(:created_at)
    hash.delete(:updated_at)

    m = model.new(hash)
    m.institution_id ||= 1
    m.non_duplicative_save(url: m.url)
  end

  index do
    selectable_column
    id_column
    column :kind
    column :info
    column :engine_type
    column :institution
    column :scrape_interval
    column :validated
    column :resource_type
    column :created_at
    column :updated_at
    column :url
    actions
  end

  form do |f|
    f.inputs 'Details' do
      f.input :kind
      f.input :info
      f.input :engine_type, collection: ScrapeResource::ENGINES.map { |r| [r, r] }
      f.input :institution
      f.input :scrape_interval
      f.input :validated
      f.input :resource_type
      f.input :url
    end
    f.inputs 'Resource Urls' do
      f.has_many :resource_urls do |j|
        j.inputs :info, :url
      end
    end
    f.inputs 'Selectors' do
      f.has_many :selectors do |j|
        j.inputs :info, :selector, :parent, :top_level, :data_resource, :scrape_resource
      end
    end
    f.actions
  end

  sidebar 'Resource Urls', only: :show do
    table_for scrape_resource.resource_urls do |t|
      t.column('URL') { |ru| ru.url }
    end
  end
end
