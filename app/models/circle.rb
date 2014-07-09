class Circle < ActiveRecord::Base
  include ModelDatabaseValidations
# verified
  ### circle event creation ###
  has_many :simple_events #

  ### circle members ###
  has_many :users, :through => :circle_members #

  ### circle's home institution ###
  belongs_to :institution #

  ### circle's activity ###
  has_many :activity_logs #

  # validates :institution_id, :presence => true, :numericality => true
  # validates :user_id, :presence => true, :numericality => true
  # validates :circle_name, :presence => true
  before_save :validate_institution_id, :validate_circle_name, :validate_user_id
end
