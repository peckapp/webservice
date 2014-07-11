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
  # validate :institution_id, :presence => true, :numericality => true
  # validate :club_name, :presence => true
  # validate :user_id, :numericality => true, :allow_nil => true
  # validate :correct_club_types
  ###################


  ### Callbacks ###
  # before_save :sanitize_club
  # before_create :sanitize_club
  # before_update :sanitize_club
  ################

  ### Methods ###
  # def correct_club_types
  #   is_correct_type(institution_id, Fixnum, "fixnum", :institution_id)
  #   is_correct_type(club_name, String, "string", :club_name)
  #   is_correct_type(user_id, Fixnum, "fixnum", :user_id)
  # end
  #
  # def sanitize_club
  #   sanitize_everything(attributes)
  # end
  #
  # private
  #   attributes = [id, institution_id, club_name, description, user_id, created_at, updated_at]
end
