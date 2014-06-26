module Api
  module V1
    class CirclesController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @circles = Circle.all
    end

    def show
      @circle = Circle.find(params[:id])
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
        params.require(:circle).permit(:institution_id, :user_id, :circle_name, :image_link, :created_at, :updated_at)
      end
    end
  end
end
