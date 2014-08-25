ActiveAdmin.register Institution do

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name, :street_address, :city, :state, :country, :gps_longitude, :gps_latitude, :range,
                :configuration_id, :api_key, :email_regex, :public
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  # Adds this into a dropdown in the top menu bar
  menu parent: 'Institutional', priority: 1

  form do |f|
    f.inputs 'Details' do
      f.input :name
      f.input :street_address
      f.input :city
      f.input :state
      f.input :country, as: :string
      f.input :gps_longitude
      f.input :gps_latitude
      f.input :range
      f.input :configuration_id
      f.input :email_regex
      f.input :public, as: :radio
      f.input :api_key
    end
    f.actions
  end

end
