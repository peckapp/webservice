class ResourceUrl < ActiveRecord::Base

  ### VALIDATIONS ###
  validates :url, presence: true, format: { with: URI::regexp(%w(http https)), message: 'url must have proper format'}
  validates :scrape_resource_id, presence: true
  validates_associated :scrape_resource

  ### these urls belong to a scrape resource
  belongs_to :scrape_resource

end
