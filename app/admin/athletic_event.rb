ActiveAdmin.register AthleticEvent do

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :title, :description, :institution_id, :athletic_team_id, :scrape_resource_id, :opponent, :team_score,
                :opponent_score, :home_or_away, :location, :result, :note, :default_score, :start_date, :end_date,
                :default_score, :image
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

  index do
    selectable_column
    id_column
    column :title
    column :athletic_team
    column :opponent
    column :institution
    column :description
    column :location
    column :start_date
    column :end_date
    column :home_or_away
    column :result
    column :team_score
    column :opponent_score
    column :note
    column :default_score
    column :scrape_resource
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs 'Details' do         # builds an input field for every attribute
      f.input :title
      f.input :athletic_team
      f.input :opponent
      f.input :institution
      f.input :description
      f.input :location
      f.input :start_date # as: :just_datetime_picker #, datepicker_options: { min_date: 3.days.ago.to_date, max_date: "+1W +5D" }
      f.input :end_date # as: :date_picker, datepicker_options: { min_date: 3.days.ago.to_date, max_date: "+1W +5D" }
      f.input :home_or_away
      f.input :result
      f.input :team_score
      f.input :opponent_score
      f.input :note
      f.input :default_score
      f.input :scrape_resource
      f.input :image, as: :file, hint: f.template.image_tag(f.object.image.url(:detail))
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

end
