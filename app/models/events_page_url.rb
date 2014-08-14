class EventsPageUrl < ActiveRecord::Base
  include ModelNormalValidations

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  # institution where events are taking place
  belongs_to :institution #

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :institution_id, presence: true, numericality: { only_integer: true }
  validates :url, presence: true
  validate :correct_events_page_url_types

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  private
  def correct_events_page_url_types
    is_correct_type(url, String, 'string', :url)
    is_correct_type(events_page_url_type, String, 'string', :events_page_url_type)
  end
end
