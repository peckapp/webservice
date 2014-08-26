class Subscription < ActiveRecord::Base
  include ModelNormalValidations

  SUBSCRIPTION_CATEGORIES = %w(department club athletic)

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :category, presence: true
  validates :category, inclusion: { in: SUBSCRIPTION_CATEGORIES, message: '%{value} is not an available category' }
  validates :subscribed_to, presence: true, numericality: { only_integer: true }
  validates :institution_id, presence: true, numericality: { only_integer: true }
  validate :correct_subscription_types

  ###############################
  ##                           ##
  ##        ASSOCIATIONS       ##
  ##                           ##
  ###############################

  ### Institution ###
  belongs_to :institution

  ### user subscriptions ###
  belongs_to :user #

  ### subscriptions of an institution ###
  belongs_to :institution

  ###############################
  ##                           ##
  ##       HELPER METHODS      ##
  ##                           ##
  ###############################

  private

  def correct_subscription_types
    is_correct_type(category, String, 'string', :category)
  end
end
