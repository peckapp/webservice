ActiveAdmin.register CrawlSeed do

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :info, :url, :regex, :active, :institution_id
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  # Adds this into a dropdown in the top menu bar
  menu parent: 'Scraping', priority: 6

end
