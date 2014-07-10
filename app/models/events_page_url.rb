class EventsPageUrl < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Associations ###
  # institution where events are taking place 
  belongs_to :institution #
  #####################

  ### Validations ###
  # validates :institution_id, :presence => true, :numericality => true
  # validates :url, :presence => true, :format => {:with => URL_REGEX}
  # validate :correct_events_page_url_types
  #####################

  ### Callbacks ###
  # before_save :sanitize_events_page_url
  # before_create :sanitize_events_page_url
  # before_update :sanitize_events_page_url
  #################

  ### Methods ###
  # def correct_events_page_url_types
  #   is_correct_type(url, String, "string", :url)
  #   is_correct_type(events_page_url_type, String, "string", :events_page_url_type)
  # end
  #
  # def sanitize_events_page_url
  #   sanitize_everything(attributes)
  # end

  # private
  #   attributes = [id, institution_id, url, events_page_url_type, created_at, updated_at]
end
