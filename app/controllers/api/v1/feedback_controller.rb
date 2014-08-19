module Api
  module V1
    # handles user feesback from the app
    class FeedbackController < ApplicationController
      # allows for user submitted feedback
      def submit
        # use an action mailer to email us the user feedback
      end
    end
  end
end
