class Department < ActiveRecord::Base
# all verified
  ### department event creation ###
  has_many :simple_events

  ### department's home institution ###
  belongs_to :institution
end
