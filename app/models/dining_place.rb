class DiningPlace < ActiveRecord::Base
  belongs_to :institution
  has_and_belongs_to_many :menu_items
end
