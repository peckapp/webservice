class Circle < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  ### circle event creation ###
  has_many :simple_events #

  ### circle members ###
  has_many :circle_members
  has_many :users, :through => :circle_members #

  ### circle's home institution ###
  belongs_to :institution #

  ### circle's activity ###
  has_many :activity_logs #

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validates :user_id, :presence => true, :numericality => { :only_integer => true }
  validates :circle_name, :presence => true
  validates :image_link, :uniqueness => true, :allow_nil => true
  validate :correct_circle_types

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  private
  def correct_circle_types
    is_correct_type(circle_name, String, "string", :circle_name)
    is_correct_type(image_link, String, "string", :image_link)
  end
end
