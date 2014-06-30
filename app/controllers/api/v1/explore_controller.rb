module Api
  module V1
    class ExploreController < ApplicationController #Api::BaseController

      respond_to :json
      
      def index
        @positions = {}
        position = 1
        @simple_events = SimpleEvent.sorted
        @explore = []
        for event in @simple_events
          if !event.start_date.past?
            if event.image_url = "null"
              event.image_url = "/images/event.png"
            end
            @positions[event.id] = position
            @explore << event
            position += 1
          end
          break if @explore.count == 5
        end
      end

    end
  end
end
