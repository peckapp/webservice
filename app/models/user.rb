class User < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations

  # each user has an encrypted secure password
  attr_accessor :enable_strict_validation, :password, :old_pass_match, :image

  EMAIL_REGEX =/\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :password, :presence => true, :length => {:minimum => 5}, :if => :enable_strict_validation
  validates :password_confirmation, :presence => true, if: lambda { |m| m.password.present? }
  validates_confirmation_of :password, if: ->{ password.present? }
  validates :first_name, :presence => true, :if => :enable_strict_validation
  validates :last_name, :presence => true, :if => :enable_strict_validation
  validates :email, :uniqueness => true, :presence => true, :length => {:maximum => 50}, :format => {:with => EMAIL_REGEX}, :if => :enable_strict_validation
  validates :facebook_link, :uniqueness => true, :allow_nil => true
  validates :facebook_token, :uniqueness => true, :allow_nil => true
  validates :api_key, :uniqueness => true, :allow_nil => true
  validate :correct_user_types

  # image validations
  has_attached_file :image, :url => "/images/users/:style/:basename.:extension", :path => ":rails_root/public/images/users/:style/:basename.:extension", :default_url => "/images/missing.png" # :styles => { :medium => "300x300>", :thumb => "100x100>" },
  # validates_attachment :image, :content_type => { :content_type => "image/jpeg"}
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, :attributes => :image, :less_than => 5.megabytes

  ###############################
  ##                           ##
  ##         CALLBACKS         ##
  ##                           ##
  ###############################

  before_save :encrypt_password
  before_create :generate_api_key

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  # user's home institution ###
  belongs_to :institution #
  ###############################

  #### CIRCLES ###
  has_many :circle_members #
  has_many :circles, :through => :circle_members #
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

  ### ANNOUNCEMENTS ###
  has_many :announcements
  #####################

  ### devices on which peck is used ###
  has_and_belongs_to_many :user_device_tokens
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

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  def self.authenticate(email, password)
    unless email.blank? || password.blank?
      user = self.where(:email => email).first

      if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
        user
      end
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

    def generate_api_key
      begin
        self.api_key = SecureRandom.hex(25)
      end while self.class.exists?(api_key: api_key)
    end
end
