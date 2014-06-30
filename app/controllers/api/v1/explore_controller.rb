module Api
  module V1
    class ExploreController < ApplicationController #Api::BaseController

      respond_to :json

      def index
        @positions ={}
        position = 1
        @simple_events = SimpleEvent.sorted
        puts DateTime.now.utc
        @explore = []
        for event in @simple_events
          puts event
          if !event.start_date.past?
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
