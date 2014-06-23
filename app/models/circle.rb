class Circle < ActiveRecord::Base
  has_many :simple_events
  has_many :users, :through => :circle_members
  belongs_to :institution
  has_many :activity_logs
end
