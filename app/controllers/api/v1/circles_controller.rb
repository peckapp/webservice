module Api
  module V1
    class CirclesController < ApplicationController #Api::BaseController

      # before_action :confirm_logged_in
      # :except => [:index, :show]

      # give circle admin power?
      respond_to :json

      def index
        search_params = []

        # collect all relevent search parameters from url
        for key in params.keys do
          break if key == "format" || "authentication"
          search_params << key
        end

        @circles = specific_index(Circle, search_params)

        # hash mapping circle id to array of its members for display in json
        @member_ids = {}

        for c in @circles
            @member_ids[c.id] = CircleMember.where("circle_id" => c.id).pluck(:user_id)
        end

      end

      def show
        if params[:user_id]
          @circle = specific_show(Circle, :user_id)
        else
          @circle = specific_show(Circle, :institution_id)
        end

        # array of this circle's members for display in json
        @member_ids = CircleMember.where("circle_id" => params[:id]).pluck(:user_id)
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
