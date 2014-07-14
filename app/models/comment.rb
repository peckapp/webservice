class Comment < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Associations
  # author of comment
  belongs_to :user #

  # Institution
  belongs_to :institution
  ###################

  ### Validations ###
  validates :category, :presence => true, :format => {:with => LETTERS_REGEX}
  validates :comment_from, :presence => true, :numericality => { :only_integer => true }
  validates :content, :presence => true
  validates :user_id, :presence => true, :numericality => { :only_integer => true }
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validate :correct_comment_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_comment
  # before_create :sanitize_comment
  # before_update :sanitize_comment
  #################

  ### Methods ###
  private
    def correct_comment_types
      is_correct_type(category, String, "string", :category)
    end

  # def sanitize_comment
  #   sanitize_everything(attributes)
  # end

  # private
  #   attributes = [id, category, comment_from, user_id, content, created_at, updated_at, institution_id]
end
