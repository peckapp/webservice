class PushNotification < ActiveRecord::Base
# verified
  ### Validations ###
  # validates_presence_of :user_id
  # validates_presence_of :type
  ###################

  ### Callbacks ###
  #################

  ### user associated to notification ###
  belongs_to :user #
end
