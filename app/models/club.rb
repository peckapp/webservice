class Club < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified
  ### club event creation ###
  has_many :simple_events #

  ### club home institution ###
  belongs_to :institution #

  ### club administrator (only one admin per club?) ###
  has_one :admin, :class_name => "User", :foreign_key => "user_id" #

  ### Validations ###
  validate :institution_id, :presence => true, :numericality => { :only_integer => true }
  validate :club_name, :presence => true
  validate :user_id, :numericality => { :only_integer => true }, :allow_nil => true
  validate :correct_club_types
  ###################


  ### Callbacks ###
  # before_save :sanitize_club
  # before_create :sanitize_club
  # before_update :sanitize_club
  ################

  ### Methods ###
  private
    def correct_club_types
      is_correct_type(club_name, String, "string", :club_name)
    end
  #
  # def sanitize_club
  #   sanitize_everything(attributes)
  # end
  #
  # private
  #   attributes = [id, institution_id, club_name, description, user_id, created_at, updated_at]
end
