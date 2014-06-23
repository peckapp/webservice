class Club < ActiveRecord::Base

  ### club event creation ###
  has_many :simple_events

  ### club home institution ###
  belongs_to :institution

  ### club administrator (only one admin per club?) ###
  has_one :admin, :class_name => "User", :foreign_key => "user_id" 
end
