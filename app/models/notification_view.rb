class NotificationView < ActiveRecord::Base
# verified
  ### notofication is viewed by its host user ###
  belongs_to :user #

  ### notification => activity log ###
  belongs_to :activity_log #
end
