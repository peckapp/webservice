class CircleMember < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  # Institution
  belongs_to :institution

  ### joins circles to users ###
  belongs_to :circle #
  belongs_to :member, class_name: 'User', foreign_key: 'user_id' #

  ### inviters of each circle member ###
  belongs_to :inviter, class_name: 'User', foreign_key: 'invited_by' #

  belongs_to :institution

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :circle_id, presence: true, numericality: { only_integer: true }
  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :invited_by, presence: true, numericality: { only_integer: true }
  validates :institution_id, presence: true, numericality: { only_integer: true }
  validate :correct_circle_member_types

  ###############################
  ##                           ##
  ##       HELPER METHODS       ##
  ##                           ##
  ###############################
  private
  def correct_circle_member_types
    is_correct_type(date_added, Time, 'datetime', :date_added)
  end
end
