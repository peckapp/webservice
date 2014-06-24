class PushNotification < ActiveRecord::Base
# verified
  ### user associated to notification ###
  belongs_to :user #
end
