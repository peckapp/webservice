class Institution < ActiveRecord::Base
  has_many :users
  has_one :configuration
  has_many :departments
  has_many :locations
  has_many :dining_places
  has_many :menu_items
  has_many :circles #anthoney
  has_many :athletic_events # anthoney. an institution has many athletic events.
  has_many :athletic_teams # anthoney. an institution has many athletic teams.
  has_many :clubs # anthoney. an institution has many clubs.
  has_many :dining_opportunities # anthoney

end
