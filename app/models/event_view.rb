class EventView < ActiveRecord::Base
  include ModelNormalValidations

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  # Institution
  belongs_to :institution

  # user who viewed the event
  has_many :users #

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :category, presence: true, format: { with: LETTERS_REGEX }
  validates :event_viewed, presence: true, numericality: { only_integer: true }
  validates :institution_id, presence: true, numericality: { only_integer: true }
  validate :correct_event_view_types

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  private
  def correct_event_view_types
    is_correct_type(category, String, 'string', :category)
    is_correct_type(date_viewed, Time, 'datetime', :date_viewed)
  end
end
