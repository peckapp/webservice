class CrawlSeed < ActiveRecord::Base

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  has_many :institutions

end
