module Api
  module V1
    class CirclesController < ApplicationController #Api::BaseController

      # before_action :confirm_logged_in
      # :except => [:index, :show]

      # give circle admin power?
      respond_to :json

      def index
        if params[:user_id]
          @circles = Circle.where(:user_id => params[:user_id])
        else
          @circles = institution_index(Circle)
        end
      end

      def show
        if params[:user_id]
          @circle = Circle.where(:user_id => params[:user_id]).find(params[:id])
        else
          @circle = institution_show(Circle)
        end
      end

      def index
        @circles = institution_index(Circle)
      end

      def show
        @circle = institution_show(Circle)
      end

      def create
        @circle = Circle.create(circle_params)
      end

      def update
        @circle = Circle.find(params[:id])
        @circle.update_attributes(circle_params)
      end

      def destroy
        @circle = Circle.find(params[:id]).destroy
      end

      private

        def circle_params
          params.require(:circle).permit(:institution_id, :user_id, :circle_name, :image_link)
        end
    end
  end
end
