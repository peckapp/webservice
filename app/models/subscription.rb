class Subscription < ActiveRecord::Base
  has_and_belongs_to_many :users # anthoney, many people have same subscriptions. Many subscriptions have same users.
end
