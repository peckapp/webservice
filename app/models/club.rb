class Club < ActiveRecord::Base
  has_many :simple_events
  belongs_to :institution # anthoney.club belongs to specific institution
  has_one :admin, :class_name => "User", :foreign_key => "user_id" # anthoney. a club has one admin.
end
