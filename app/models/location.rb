class Location < ActiveRecord::Base
# verified
  ### a location has just one institution ###
  belongs_to :institution
end
