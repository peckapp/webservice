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
  # validates :category, :presence => true, :format => {:with => LETTERS_REGEX}
  # validates :comment_from, :presence => true, :numericality => true
  # validates :content, :presence => true
  # validates :user_id, :presence => true, :numericality => true
  # validates :institution_id, :presence => true, :numericality => true
  # validate :correct_comment_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_comment
  # before_create :sanitize_comment
  # before_update :sanitize_comment
  #################

  ### Methods ###
  # def correct_comment_types
  #   is_correct_type(category, String, "string", :category)
  #   is_correct_type(comment_from, Fixnum, "fixnum", :comment_from)
  #   is_correct_type(user_id, Fixnum, "fixnum", :user_id)
  #   is_correct_type(institution_id, Fixnum, "fixnum", :institution_id)
  # end

  # def sanitize_comment
  #   sanitize_everything(attributes)
  # end

  # private
  #   attributes = [id, category, comment_from, user_id, content, created_at, updated_at, institution_id]
end
