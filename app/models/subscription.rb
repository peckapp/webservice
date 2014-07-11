class Subscription < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Validations ###
  # validates :user_id, :presence => true, :numericality => true
  # validates :category, :presence => true
  # validates :subscribe_to, :presence => true, :numericality => true
  # validates :institution_id, :presence => true, :numericality => true
  # validate :correct_subscription_types
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

  # def correct_subscription_types
  #   is_correct_type(user_id, Fixnum, "fixnum", :user_id)
  #   is_correct_type(category, String, "string", :category)
  #   is_correct_type(subscribed_to, Fixnum, "fixnum", :subscribed_to)
  #   is_correct_type(institution_id, Fixnum, "fixnum", :institution_id)
  # end
  #
  # def sanitize_subscription
  #   sanitize_everything(attributes)
  # end
  #
  # private
  #   attributes = [id, user_id, category, subscribed_to, created_at, updated_at, institution_id]
end
