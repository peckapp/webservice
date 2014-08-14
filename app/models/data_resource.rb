class DataResource < ActiveRecord::Base
  ### VALIDATIONS ###
  validates_associated :scrape_resources
  validated_associated :data_resources

  validates :column_name, inclusion: { in: %w(small medium large), message: "%{value} is not a valid size" }

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

  # model can be nil if it doesn't exist
  def model
    ResourceType.find(resource_type_id).model
  end

  def to_label
    info
  end
end
