class Subscription < ActiveRecord::Base
# verified

  ### Validations ###
  # validates_presence_of :user_id
  ###################

  ### Callbacks ###
  #################

  ### user subscriptions ###
  belongs_to :user #

  ### subscriptions of an institution ###
  belongs_to :institution
end
