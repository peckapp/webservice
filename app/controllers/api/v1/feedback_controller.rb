module Api
  module V1
    # handles user feesback from the app
    class FeedbackController < ApplicationController
      # allows for user submitted feedback
      def submit
        user_id = params[:user_id]
        content = params[:content]
        category = params[:category]
        institution_id = params[:institution_id]
        Communication::Feedback.perform_async(user_id, content, category, institution_id)
      end
    end
  end
end
