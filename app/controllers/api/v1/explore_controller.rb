module Api
  module V1
    # this class handles the output of the explore feed, speficif to the user requesting it
    class ExploreController < ApplicationController
      respond_to :json

      # for now, just returns the 5 most recent events
      def index
        @positions = {}
        position = 1
        @simple_events = specific_index(SimpleEvent, params).sorted
        @explore = []
        @simple_events.each do |event|
          unless event.start_date.past?
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
