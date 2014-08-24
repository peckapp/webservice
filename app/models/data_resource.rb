class DataResource < ActiveRecord::Base
  ### VALIDATIONS ###
  validates :column_name, presence: true # , inclusion: { in: %w(small medium large), message: "%{value} is not a valid size" }

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  belongs_to :resource_type

  ### each selector has a DataResource that defines for which column that data applies in the given model
  has_many :selectors

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  # performs a current_or_create_new operation for just this resource's model and column_name with the given value
  def minimal_current_or_new(value)
    model.current_or_new(column_name => value)
  end

  # model can be nil if it doesn't exist
  def model
    ResourceType.find(resource_type_id).model
  end

  def display_name
    info
  end
end
