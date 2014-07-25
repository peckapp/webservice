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
        end
      end

      def update
        @subscription = Subscription.find(params[:id])
        @subscription.update_attributes(subscription_update_params)
      end

      def destroy
        # makes sure the id in the delete request matches the user id.
        if params[:id].to_i == auth[:user_id].to_i
          @subscriptions = []

          # query parameter with the ids of all the necessarily deleted subscriptions
          subscription_id_string = params[:subscriptions]

          # converts the query parameter string into an array. Query parameter gets sent like this "[1,2,3]"
          all_ids = subscription_id_string[subscription_id_string.index("[") + 1, subscription_id_string.index("]") - 1].split(",")

          # for each id in the array of ids, find the Subscription with that id, add it to the array of deleted subscriptions
          # for the view, and then destroy the subscription
          all_ids.each do |id|
            this_subscription = Subscription.find(id)
            @subscriptions << this_subscription
            this_subscription.destroy
          end
        else
          # if parameter for the id does not match the user id, then do not destroy subscriptions! Instead send an unauthorized.
          head :unauthorized
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
