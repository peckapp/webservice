class DiningOpportunity < ActiveRecord::Base
# verified
  ### home institution for this dining opportunity ###
  belongs_to :institution #

  ### opportunities for these dining periods ###
  has_and_belongs_to_many :dining_periods #
end
