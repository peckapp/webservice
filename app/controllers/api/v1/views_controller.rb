module Api
  module V1
    class ViewsController < ApplicationController #Api::BaseController

      # before_action :authenticate_admin_user!, :only => [:create, :update, :destroy]
      # before_action => :confirm_admin, :only => [:create, :update, :destroy]

      respond_to :json

      def index
        @views = specific_index(View, params)
      end

      def show
        @view = specific_show(View, params[:id])
      end

      def create
        @view = View.create(view_params)
      end

      def update
        @view = View.find(params[:id])
        @view.update_attributes(view_params)
      end

      def destroy
        @view = View.find(params[:id]).destroy
      end

      private

        def view_params
          params.require(:view).permit(:institution_id, :user_id, :category, :content_id, :date_viewed)
        end
    end
  end
end
