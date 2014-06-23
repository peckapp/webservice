class Subscription < ActiveRecord::Base
# verified
  ### user subscriptions ###
  has_and_belongs_to_many :users #
end
