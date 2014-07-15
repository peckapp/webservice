class User < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
  # verified
  ########
  # each user has an encrypted secure password
  attr_accessor :enable_strict_validation

  EMAIL_REGEX =/\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/
  # validate :password_is_not_blank, :if => :enable_strict_validation
  validates :password, :presence => true, :if => :enable_strict_validation
  validates :password_confirmation, :presence => true, if: lambda { |m| m.password.present? }
  validates_confirmation_of :password, if: ->{ password.present? }
  validates :first_name, :presence => true, :if => :enable_strict_validation
  validates :last_name, :presence => true, :if => :enable_strict_validation
  validates :email, :uniqueness => true, :presence => true, :length => {:maximum => 50}, :format => {:with => EMAIL_REGEX}, :if => :enable_strict_validation
  # validates :authentication_token, :presence => true, :uniqueness => true, :if => :enable_strict_validation
  ########

  #### Callbacks #######
  # before_save :sanitize_user
  # before_create :sanitize_user
  # before_update :sanitize_user
  ######################


  #### Validations ###############
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validates :facebook_link, :uniqueness => true, :allow_nil => true
  validates :facebook_token, :uniqueness => true, :allow_nil => true
  validates :api_key, :uniqueness => true, :allow_nil => true
  validate :correct_user_types

  ###############################

  ################################# Associations ####################################
  # user's home institution ###
  belongs_to :institution #
  ###############################

  #### CIRCLES ###
  has_many :circles, :through => :circle_members #
  has_many :circle_members #
  ################

  ### EVENTS ###
  has_many :simple_events #
  has_many :event_attendees #
  has_many :event_attendees_as_inviters, :class_name => "EventAttendee" #
  ##############

  ### CLUBS ####
  belongs_to :club #
  ##############

  ### EVENT COMMENTS ###
  has_many :comments #
  ######################

  ### SUBSCRIPTIONS ###
  has_many :subscriptions #
  #####################

  ### devices on which peck is used ###
  has_and_belongs_to_many :user_device_tokens #
  #####################################

  ### user viewed a specific event ###
  belongs_to :event_view #
  ####################################

  ### ACTIVITY LOG ###
  has_many :activity_logs_sent, :class_name => "ActivityLog" #
  has_many :activity_logs_received, :class_name => "ActivityLog" #
  ####################

  ### NOTIFICATIONS ###
  has_many :notification_views #
  has_many :push_notifications #
  #####################

  ######################################################################################

  ### Methods ###
  def self.authenticate(email, password)
   user = self.where(:email => email)

   if user && user.password_digest == BCrypt::Engine.hash_secret(password, user.password_salt)
     user
   end
 end

 def encrypt_password
   if password.present?
     self.password_salt = BCrypt::Engine.generate_salt
     self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
   end
 end

  private
    def correct_user_types
      is_correct_type(first_name, String, "string", :first_name)
      is_correct_type(last_name, String, "string", :last_name)
      is_correct_type(email, String, "string", :username)
      is_correct_type(facebook_link, String, "string", :facebook_link)
      is_correct_type(facebook_token, String, "string", :facebook_token)
      is_correct_type(api_key, String, "string", :api_key)
      is_correct_type(authentication_token, String, "string", :authentication_token)
    end
    #
    # def password_is_not_blank
    #   errors.add(:password, "must not be blank") unless password_digest.present?
    #   # && self.enable_strict_validation
    # end

  #
  # def sanitize_user
  #   sanitize_everything(attributes)
  # end
  #
  # private
  #   attributes = [id, institution_id, first_name, last_name, username, blurb, facebook_link, facebook_token, password_digest, api_key, active, created_at, updated_at, authentication_token]
end
