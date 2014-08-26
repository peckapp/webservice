class UdidUser < ActiveRecord::Base
  include ModelNormalValidations

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :unique_device_identifier_id, presence: true
  validates :user_id, presence: true

  ###############################
  ##                           ##
  ##        ASSOCIATIONS       ##
  ##                           ##
  ###############################

  belongs_to :user
  belongs_to :unique_device_identifier

  ###############################
  ##                           ##
  ##       HELPER METHODS      ##
  ##                           ##
  ###############################
  scope :sorted, -> { order('udid_users.updated_at ASC') }
end
