ActiveAdmin.register DiningOpportunity do


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
  menu :parent => "Dining"

  # active admin seems to have broken filter generations for simple joins
  remove_filter :diningopportunities_dining_places
  filter :dining_opportunities_dining_places

end
