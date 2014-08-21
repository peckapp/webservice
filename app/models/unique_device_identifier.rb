class UniqueDeviceIdentifier < ActiveRecord::Base
  include ModelNormalValidations

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :udid, uniqueness: true
  validates inclusion: { in: %w(ios android), message: "%{value} is not a valid device type from ['ios', 'android']" }

  ###############################
  ##                           ##
  ##        ASSOCIATIONS       ##
  ##                           ##
  ###############################

  ### device is associated to a particular user ###
  has_many :udid_users
  has_many :users, through: :udid_users

  ###############################
  ##                           ##
  ##       HELPER METHODS      ##
  ##                           ##
  ###############################
  scope :sorted, -> { order('unique_device_identifiers.updated_at ASC') }

  def display_name
    udid
  end

  private

  def correct_unique_device_identifier_types
    is_correct_type(udid, String, 'string', :udid)
  end
end
