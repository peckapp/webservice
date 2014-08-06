ActiveAdmin.register AthleticEvent do

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

  #### THESE SHOULD NOT HAVE TO BE HERE ####
  # need to figure out root cause of errors and solve them
  remove_filter :home_or_away
  remove_filter :date_and_time

end
