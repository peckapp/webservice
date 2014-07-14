# scrapes middlebury's dining menus
class MiddleburyDiningWorker

  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(2) }

  def perform

  end

end
