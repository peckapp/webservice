module Api
  module V1
    class CirclesController < ApplicationController #Api::BaseController

      # before_action :confirm_logged_in
      # :except => [:index, :show]

      # give circle admin power?
      respond_to :json

      def index
        search_params = []

        for key in params.keys do
          break if key == "format"
          search_params << key
        end
        @circles = specific_index(Circle, search_params)
      end

      def show
        if params[:user_id]
          @circle = specific_show(Circle, :user_id)
        else
          @circle = specific_show(Circle, :institution_id)
        end
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
