class EventView < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Associations ###
  # Institution
  belongs_to :institution

  # user who viewed the event
  has_many :users #
  ####################
  
  ### Validations ###
  # validates :user_id, :presence => true, :numericality => true
  # validates :category, :presence => true, :format => {:with => LETTERS_REGEX}
  # validates :event_viewed, :presence => true, :numericality => true
  # validates :institution_id, :presence => true, :numericality => true
  # validate :correct_event_view_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_event_view
  # before_create :sanitize_event_view
  # before_update :sanitize_event_view
  #################

  ### Methods ###
  # def correct_event_view_types
  #   is_correct_type(category, String, "string", :category)
  #   is_correct_type(date_viewed, DateTime, "datetime", :date_viewed)
  # end
  #
  # def sanitize_event_view
  #   sanitize_everything(attributes)
  # end
  # private
  #   attributes = [id, user_id, category, event_viewed, date_viewed, created_at, updated_at, institution_id]
end
