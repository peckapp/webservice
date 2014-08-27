# model relating a piece of data to a specific attribute of a resource_type
class DataResource < ActiveRecord::Base
  DATA_TYPES = %w(text url date image key)

  ### VALIDATIONS ###
  validates :resource_type_id, presence: true
  validates :column_name, presence: true
                          # inclusion: { in: self.resource_type.model.column_names, message: '%{value} is not a valid column' }
  validates :data_type, presence: true,
                        inclusion: { in: DATA_TYPES, message: '%{value} is not a valid data type' }

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
