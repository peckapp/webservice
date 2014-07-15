class ScrapeResource < ActiveRecord::Base

  belongs_to :resource_type

  ### each selector has a ScrapeResource from which it originated
  has_many :selectors

end
