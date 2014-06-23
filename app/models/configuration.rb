class Configuration < ActiveRecord::Base

  ### each config is for just one institution ###
  belongs_to :institution
end
