ActiveAdmin.register User do
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :institution_id, :first_name, :last_name, :last_name, :blurb, :active
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  # Adds this into a dropdown in the top menu bar
  menu parent: 'Accounts and Social'

  # remove_filter :users_user_device_tokens
  # filter :user_device_tokens_users

  sidebar 'Unique Device Identifiers', only: :show do
    table_for user.unique_device_identifiers do |t|
      t.column('Identifier') { |udi| udi.udid }
      t.column('Token') { |udi| udi.token }
    end
  end

  index do
    selectable_column
    id_column
    column :institution
    column :first_name
    column :last_name
    column :email
    column :api_key
    column :active
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do # builds an input field for specified attributes
      row :id
      row :active
      row :institution
      row :first_name
      row :last_name
      row :email
      row :blurb
      row :facebook_link
      row :facebook_token
      row :api_key
      row :authentication_token
      row :password_hash
      row :password_salt
      row :image do
        image_tag(user.image.url(:detail))
      end
      row :created_at
      row :updated_at
    end
  end

end
