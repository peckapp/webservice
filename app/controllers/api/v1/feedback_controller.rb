module Api
  module V1
    # handles user feesback from the app
    class FeedbackController < ApplicationController
      # allows for user submitted feedback
      def submit
        user_id = params[:user_id]
        content = params[:content]
        category = params[:category]
        Communication::Feedback.perform_async(user_id, content, category)
      end
    end
  end
end
