ActiveAdmin.register DataResource do

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :info, :column_name, :data_type, :resource_type_id, :foreign_key
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  # Adds this into a dropdown in the top menu bar
  menu parent: 'Scraping', priority: 4

  active_admin_importable do |model, hash|
    # delete things that are unique to a specific database
    hash.delete(:id)
    hash.delete(:created_at)
    hash.delete(:updated_at)

    m = model.new(hash)
    m.resource_type_id ||= 1
    m.non_duplicative_save(column_name: m.column_name)
  end

  # some hackery to get a hash of column names with their model associated with the actual column name
  # if we are able to use javascript for selector options, just the top line will be needed to get models to columns
  mc = Hash[ResourceType.all.map { |rt| rt.model }.map do |m|
    [m, m.column_names.flatten.uniq +
        ((defined? m.attachment_definitions) ? m.attachment_definitions.keys.map { |k| k.to_s } : [])]
  end]
  names = mc.keys.reduce([]) { |a, k| a << mc[k].reduce([]) { |b, v| b << [k.name, v.to_s] } }.flatten(1)

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs 'Details' do         # builds an input field for every attribute
      f.input :resource_type, collection: Hash[ResourceType.all.map { |rt| [rt.model_name, rt.id] }]
      f.input :column_name, collection: Hash[names.map { |m, c| ["#{m} => #{c}", c] }]
      f.input :data_type, collection: Hash[DataResource::DATA_TYPES.map { |t| [t, t] }]
      f.input :foreign_key, as: :radio
      f.input :info
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  index do
    selectable_column
    id_column
    column :info
    column :column_name
    column :foreign_key
    column :data_type
    column :resource_type
    column :created_at
    column :updated_at
    actions
  end

end
