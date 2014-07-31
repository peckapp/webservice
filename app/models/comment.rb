class Comment < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations

  acts_as_likeable
  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  # author of comment
  belongs_to :user #

  # Institution
  belongs_to :institution

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :category, presence: true, format: { with: LETTERS_REGEX }
  validates :comment_from, presence: true, numericality: { only_integer: true }
  validates :content, presence: true
  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :institution_id, presence: true, numericality: { only_integer: true }
  validate :correct_comment_types

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  private
  def correct_comment_types
    is_correct_type(category, String, 'string', :category)
  end
end
