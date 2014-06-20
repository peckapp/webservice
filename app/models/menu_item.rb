class MenuItem < ActiveRecord::Base
  has_one :institution
  has_and_belongs_to_many :dining_places
end
