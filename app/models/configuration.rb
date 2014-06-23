class Configuration < ActiveRecord::Base
# verified
  ### each config is for just one institution ###
  belongs_to :institution #
end
