class Configuration < ActiveRecord::Base
# verified
  ### each config is for just one institution ###
  has_one :institution #
end
