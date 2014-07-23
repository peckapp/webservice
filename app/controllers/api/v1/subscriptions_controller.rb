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
        @subscription = Subscription.find(params[:id]).destroy
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
