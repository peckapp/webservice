class ScrapeResource < ActiveRecord::Base
  belongs_to :institution

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
