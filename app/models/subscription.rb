class Subscription < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Validations ###
  validates :user_id, :presence => true, :numericality => { :only_integer => true }
  validates :category, :presence => true
  validates :subscribed_to, :presence => true, :numericality => { :only_integer => true }
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validate :correct_subscription_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_subscription
  # before_create :sanitize_subscription
  # before_update :sanitize_subscription
  #################

  ### Institution ###
  belongs_to :institution

  ### user subscriptions ###
  belongs_to :user #

  ### subscriptions of an institution ###
  belongs_to :institution

  private
    def correct_subscription_types
      is_correct_type(category, String, "string", :category)
    end
  #
  # def sanitize_subscription
  #   sanitize_everything(attributes)
  # end
  #
  # private
  #   attributes = [id, user_id, category, subscribed_to, created_at, updated_at, institution_id]
end
