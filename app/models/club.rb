class Club < ActiveRecord::Base
  include ModelBeforeSaveValidations
# verified
  ### club event creation ###
  has_many :simple_events #

  ### club home institution ###
  belongs_to :institution #

  ### club administrator (only one admin per club?) ###
  has_one :admin, :class_name => "User", :foreign_key => "user_id" #

  # validate :institution_id, :presence => true, :numericality => true
  # validate :club_name, :presence => true
end
