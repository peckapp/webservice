class Department < ActiveRecord::Base
  has_many :simple_events
  belongs_to :institution
end
