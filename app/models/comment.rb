class Comment < ActiveRecord::Base
# verified
  ### author of comment ###
  belongs_to :user #

  ### Institution ###
  belongs_to :institution
end
