class ScrapeResource < ActiveRecord::Base
  ### VALIDATIONS ###
  validates :engine_type, inclusion: { in: %w(nested simple), message: "%{value} is not an available engine" }

  # this is the only point in the scraping data network where it is connected to an institution_ids
  belongs_to :institution

  # a resource type indicates the model to which the data in this resource relates
  belongs_to :resource_type

  ### each selector has a ScrapeResource from which it originated
  has_many :selectors

  ### each scrape resource has at least one url which fits the format of that resource
  has_many :resource_urls

  accepts_nested_attributes_for :selectors

  def paginated?
    pagination_selector_id.blank?
  end

  # for active admin
  def to_label
    info
  end

  # model can be nil if it doesn't exist
  def model
    ResourceType.find(resource_type_id).model
  end
end
