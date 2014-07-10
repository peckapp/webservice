class DiningPlace < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations

# all verified

  ### Associations ###
  # home institution
  belongs_to :institution #

  # host dining place of menu item
  has_many :menu_items #

  # host dining place of dining period
  has_many :dining_periods #

  # dining opportunities #
  has_and_belongs_to_many :dining_opportunities, :join_table => :dining_opportunities_dining_places #
  ####################

  ### Validations ###
  # validates :institution_id, :presence => true, :numericality => true
  # validates :name, :presence => true
  # validate :correct_dining_place_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_dining_place
  # before_create :sanitize_dining_place
  # before_update :sanitize_dining_place
  #################

  ### Methods ###
  # def correct_dining_place_types
  #   is_correct_type(name, String, "string", :name)
  #   is_correct_type(details_link, String, "string", :details_link)
  #   is_correct_type(gps_longitude, Float, "float", :gps_longitude)
  #   is_correct_type(gps_latitude, Float, "float", :gps_latitude)
  #   is_correct_type(range, Float, "float", :range)
  #   is_correct_type(institution_id, Fixnum, "fixnum", :institution_id)
  # end
  #
  # def sanitize_dining_place
  #     sanitize_everything(attributes)
  # end
  # private
  #   attributes = [id, institution_id, name, details_link, gps_longitude, gps_latitude, range, created_at, updated_at]
end
