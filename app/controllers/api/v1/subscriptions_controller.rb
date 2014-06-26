module Api
  module V1
    class SubscriptionsController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @subscriptions = Subscription.all
    end

    def show
      @subscription = Subscription.find(params[:id])
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

        params.require(:subscription).permit(:user_id, :category, :subscribed_to)

      end
    end
  end
end
