ActiveAdmin.register Announcement do

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :title, :announcement_description, :institution_id, :user_id, :public, :start_date, :start_date,
                :deleted, :longitude, :latitude, :category, :default_score, :scrape_resource_id, :image
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

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs 'Details' do         # builds an input field for every attribute
      f.input :title
      f.input :announcement_description
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
      f.input :image, as: :file, hint: f.template.image_tag(f.object.image.url(:thumb))
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

end
