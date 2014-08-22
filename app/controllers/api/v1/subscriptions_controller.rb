module Api
  module V1
    class SubscriptionsController < ApplicationController #Api::BaseController

      # before_action => :confirm_admin, :only => [:create, :update, :destroy]

      respond_to :json

      def index
        @subscriptions = specific_index(Subscription, params)
      end

      def show
        @subscription = specific_show(Subscription, params[:id])
      end

      def create
        @subscriptions = []

        params[:subscriptions].each do |parameters|
          this_subscription = Subscription.create(subscription_create_params(parameters))
          @subscriptions << this_subscription

          # increment subscription count of corresponding dept/club/team
          if parameters[:category] == 'department'
            dept = Department.find(parameters[:subscribed_to])
            if dept.subscriber_count.nil?
              dept.subscriber_count = 1
            else
              dept.subscriber_count += 1
            end
            dept.save
          elsif parameters[:category] == 'club'
            club = Club.find(parameters[:subscribed_to])
            club.subscriber_count += 1
            club.save
          elsif parameters[:category] == 'athletic'
            team = AthleticTeam.find(parameters[:subscribed_to])
            team.subscriber_count += 1
            team.save
          end
        end
      end

      def update
        @subscription = Subscription.find(params[:id])
        @subscription.update_attributes(subscription_update_params)
      end

      # possible fix, make the array sent in a dictionary so that it won't be a string.
      def destroy
        @subscriptions = []

        # query parameter with the ids of all the necessarily deleted subscriptions
        subscription_id_string = params[:subscription][:subscriptions]

        # converts the query parameter string into an array. Query parameter gets sent like this "[1,2,3]"
        all_ids = subscription_id_string[subscription_id_string.index("[") + 1, subscription_id_string.index("]") - 1].split(",")

        # for each id in the array of ids, find the Subscription with that id, add it to the array of deleted subscriptions
        # for the view, and then destroy the subscription
        all_ids.each do |id|
          this_subscription = Subscription.find(id)
          @subscriptions << this_subscription

          # decrement subscription count of corresponding dept/club/team
          if this_subscription.category == "department"
            dept = Department.find(this_subscription.subscribed_to)
            dept.subscriber_count -= 1
            dept.save
          elsif this_subscription.category == "club"
            club = Club.find(this_subscription.subscribed_to)
            club.subscriber_count -= 1
            club.save
          else
            team = AthleticTeam.find(this_subscription.subscribed_to)
            team.subscriber_count -= 1
            team.save
          end

          this_subscription.destroy
        end
      end

      private

        def subscription_update_params
          params.require(:subscription).permit(:institution_id, :user_id, :category, :subscribed_to)
        end


        def subscription_create_params(parameters)
          parameters.permit(:institution_id, :user_id, :category, :subscribed_to)
        end
    end
  end
end
