class AthleticTeam < ActiveRecord::Base
  has_many :athletic_events # anthoney. team has many athletic events
  belongs_to :institution # anthoney. team belongs to the institution.
end
