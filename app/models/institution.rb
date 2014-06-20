class Institution < ActiveRecord::Base
  has_many :users
  has_one :configuration
  has_many :departments
  has_many :locations
  has_many :dining_places
  has_many :menu_items
end
