module Api
  module V1
    class SubscriptionsController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]

      respond_to :json

      def index
        if params[:user_id]
          @subscriptions = specific_index(Subscription, :user_id)
        else
          @subscriptions = Subscription.all
        end
      end

      def show
        if params[:user_id]
          @subscription = specific_show(Subscription, :user_id)
        else
          @subscription = Subscription.find(params[:id])
        end
      end

      def create
        @subscription = Subscription.create(subscription_params)
      end

      def update
        @subscription = Subscription.find(params[:id])
        @subscription.update_attributes(subscription_params)
      end

      def destroy
        @subscription = Subscription.find(params[:id]).destroy
      end

      private

        def subscription_params

          params.require(:subscription).permit(:institution_id, :user_id, :category, :subscribed_to)

        end
    end
  end
end
