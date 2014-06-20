class User < ActiveRecord::Base

  ########
  # each user has an encrypted secure password
  has_secure_password
  ########

  has_many :simple_events
  belongs_to :institution
end
