class DiningOpportunity < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Associations ###
  # home institution for this dining opportunity #
  belongs_to :institution #

  # opportunities for these dining periods #
  has_many :dining_periods #

  # dining places #
  has_and_belongs_to_many :dining_places, :join_table => :dining_opportunities_dining_places #

  # available menu items #
  has_many :menu_items #
  ####################

  ### Validations ###
  # validates :dining_opportunity_type, :presence => true
  # validates :institution_id, :presence => true, :numericality => true
  # validate :correct_dining_opportunity_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_dining_opportunity
  # before_create :sanitize_dining_opportunity
  # before_update :sanitize_dining_opportunity
  #################

  ### Methods ###
  # def correct_dining_opportunity_types
  #   is_correct_type(dining_opportunity_type, String, "string", :dining_opportunity_type)
  #   is_correct_type(institution_id, Fixnum, "fixnum", :institution_id)
  # end
  #
  # def sanitize_dining_opportunity
  #   sanitize_everything(attributes)
  # end
  #
  # private
  #   attributes = [id, dining_opportunity_type, institution_id, created_at, updated_at]
end
