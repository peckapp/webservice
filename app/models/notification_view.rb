class NotificationView < ActiveRecord::Base
# verified

  ### Validations ###
  # validates_presence_of :user_id
  # validates_presence_of :activity_log_id
  # validates_presence_of :viewed
  ###################

  ### Callbacks ###
  #################

  ### notification is viewed by its host user ###
  belongs_to :user #

  ### notification => activity log ###
  belongs_to :activity_log #
end
