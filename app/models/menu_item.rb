class MenuItem < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations

  ###############################
  ##                           ##
  ##         VALIDATIONS       ##
  ##                           ##
  ###############################

  validates :name, presence: true
  validates :institution_id, presence: true, numericality: { only_integer: true }
  validates :details_link, format: { with: URI.regexp(%w(http https)) }, allow_nil: true
  validates :dining_opportunity_id, presence: true, numericality: { only_integer: true }
  validates :dining_place_id, numericality: { only_integer: true }, allow_nil: true
  validates :date_available, presence: true
  validate :correct_menu_item_types

  ###############################
  ##                           ##
  ##        ASSOCIATIONS       ##
  ##                           ##
  ###############################

  ### institution where item is available ###
  belongs_to :institution #

  ### dining place where item is available ###
  belongs_to :dining_place #

  ### dining opportunity when item is available ###
  belongs_to :dining_opportunity #

  ### scrape resource from which this was gathered ###
  belongs_to :scrape_resource #

  ###############################
  ##                           ##
  ##      PRIVATE METHODS      ##
  ##                           ##
  ###############################

  private

  def correct_menu_item_types
    is_correct_type(name, String, 'string', :name)
    is_correct_type(details_link, String, 'string', :details_link)
    is_correct_type(small_price, String, 'string', :small_price)
    is_correct_type(large_price, String, 'string', :large_price)
    is_correct_type(combo_price, String, 'string', :combo_price)
    is_correct_type(date_available, Date, 'date', :date_available)
    is_correct_type(category, String, 'string', :category)
    is_correct_type(serving_size, String, 'string', :serving_size)
  end
end
