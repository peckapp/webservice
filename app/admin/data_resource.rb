ActiveAdmin.register DataResource do


  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :info, :column_name, :resource_type_id
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

  # some hackery to get a hash of column names with their model associated with the actual column name
  # if we are able to use javascript for selector options, just the top line will be needed to get models to columns
  mc = Hash[ResourceType.all.map { |rt| rt.model }.map { |m| [m, m.columns.map { |c| c.name }] }]
  names = mc.keys.reduce([]) { |a, k| a << mc[k].reduce([]) { |a2, v| a2 << [k.name, v] } }.flatten(1)

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs 'Details' do         # builds an input field for every attribute
      f.input :resource_type, collection: Hash[ResourceType.all.map { |rt| ["#{rt.info} => '#{rt.model_name}'", rt.id] }]
      f.input :column_name, collection: Hash[names.map { |m, c| ["#{m} => #{c}", c] }]
      f.input :info
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

end
