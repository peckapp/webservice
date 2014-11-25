ActiveAdmin.register SimpleEvent do

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :title, :event_description, :location, :institution, :user, :public, :start_date, :end_date, :deleted,
                :longitude, :latitude, :category, :default_score, :scrape_resource, :image
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

  index do
    selectable_column
    id_column
    column :title
    # column :event_description
    column :location
    column :institution
    column :organizer_id
    column :category
    column :user
    column :public
    column :start_date
    column :end_date
    # column :url
    column :deleted
    column :longitude
    column :latitude
    column :default_score
    column :scrape_resource
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :title
      row :event_description
      row :location
      row :institution
      row :user
      row :public
      row :start_date
      row :end_date
      row :deleted
      row :longitude
      row :latitude
      row :category
      row :url
      row :image_file_name
      row :image_url do
        simple_event.image.url
      end
      row :image do
        image_tag(simple_event.image.url(:detail))
      end
      row :default_score
      row :scrape_resource
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs 'Details' do         # builds an input field for every attribute
      f.input :title
      f.input :event_description
      f.input :location
      f.input :institution
      f.input :user
      f.input :public
      f.input :start_date # as: :just_datetime_picker #, datepicker_options: { min_date: 3.days.ago.to_date, max_date: "+1W +5D" }
      f.input :end_date # as: :date_picker, datepicker_options: { min_date: 3.days.ago.to_date, max_date: "+1W +5D" }
      f.input :deleted
      f.input :longitude
      f.input :latitude
      f.input :category
      f.input :default_score
      f.input :scrape_resource
      f.input :image, as: :file, hint: f.template.image_tag(f.object.image.url(:detail))
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

end
