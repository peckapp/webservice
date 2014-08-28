class UniqueDeviceIdentifier < ActiveRecord::Base
  include ModelNormalValidations

  DEVICE_TYPES = %w(ios android)

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :udid, presence: true, uniqueness: true
  validates :device_type, presence: true
  validates :device_type, inclusion: { in: DEVICE_TYPES, message: '%{value} is not a valid device type' }
  
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

  # finds a udi matching either parameter and updates the other parameter to match. returns an updated but unsaved object
  def self.updated_udid_token_pair(udid, token)
    udi = nil
    if (udi = UniqueDeviceIdentifier.find_by(udid: udid))
      udi.update_attributes(token: token)
    elsif (udi = UniqueDeviceIdentifier.find_by(token: token))
      udi.update_attributes(udid: udid)
    end
    udi
  end

  private

  def correct_unique_device_identifier_types
    is_correct_type(udid, String, 'string', :udid)
  end
end
