class MenuItem < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Validations ###
  # validates :name, :presence => true
  # validates :institution_id, :presence => true, :numericality => true
  # validates :dining_opportunity_id, :presence => true, :numericality => true
  # validates :dining_place_id, :numericality => true, :allow_nil => true
  # validates :date_available, :presence => true
  # validate :correct_menu_item_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_menu_item
  # before_create :sanitize_menu_item
  # before_update :sanitize_menu_item
  #################

  ### institution where item is available ###
  belongs_to :institution #

  ### dining place where item is available ###
  belongs_to :dining_place #

  ### dining opportunity when item is available ###
  belongs_to :dining_opportunity #

  ### Methods ###
  # def correct_menu_item_types
  #   is_correct_type(name, String, "string", :name)
  #   is_correct_type(institution_id, Fixnum, "fixnum", :institution_id)
  #   is_correct_type(details_link, String, "string", :details_link)
  #   is_correct_type(small_price, String, "string", :small_price)
  #   is_correct_type(large_price, String, "string", :large_price)
  #   is_correct_type(combo_price, String, "string", :combo_price)
  #   is_correct_type(dining_opportunity_id, Fixnum, "fixnum", :dining_opportunity_id)
  #   is_correct_type(dining_place_id, Fixnum, "fixnum", :dining_place_id)
  #   is_correct_type(date_available, Date, "date", :date_available)
  #   is_correct_type(category, String, "string", :category)
  #   is_correct_type(serving_size, String, "string", :serving_size)
  # end
  #
  # def sanitize_menu_item
  #   sanitize_everything(attributes)
  # end
  #
  # private
  #   attributes = [id, name, institution_id, details_link, small_price, large_price, combo_price, created_at, updated_at, dining_opportunity_id, dining_place_id, date_available, category, serving_size]
end
