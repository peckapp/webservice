class ScrapeResource < ActiveRecord::Base
  belongs_to :institution

  belongs_to :resource_type

  ### each selector has a ScrapeResource from which it originated
  has_many :selectors

  def paginated?
    pagination_selector_id.blank?
  end
end
