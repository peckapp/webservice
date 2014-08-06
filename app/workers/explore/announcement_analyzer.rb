# nests all explore workers within their own module
module Explore
  # sub worker that analyses a specific announcement
  class AnnouncementAnalyzer
    include Sidekiq::Worker

    def perform(id)
      Announcement.find(id)
    end
  end
end
