module Api
  module V1
    class DiningPlacesController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]

      respond_to :json

      def index
        if params[:dining_period_id]
          @dining_places = DiningPeriod.find(params[:dining_period_id]).dining_places
        elsif params[:menu_item_id]
          @dining_places = MenuItem.find(params[:menu_item_id]).dining_places
        else
          @dining_places = specific_index(DiningPlace, params)
        end
      end

      def show
        if params[:dining_period_id]
          @dining_place = DiningPeriod.find(params[:dining_period_id]).dining_places.find(params[:id])
        elsif params[:menu_item_id]
          @dining_place = MenuItem.find(params[:menu_item_id]).dining_places.find(params[:id])
        else
          @dining_place = specific_show(DiningPlace, :institution_id)
        end
      end

      def create
        @dining_place = DiningPlace.create(dining_place_create_params)

        @dining_period_id = dining_place_create_params[:dining_period_id]
          DiningPeriod.find(@dining_period_id).dining_places << @dining_place

        @menu_item_id = dining_place_create_params[:menu_item_id]
          MenuItem.find(@menu_item_id).dining_places << @dining_place
      end

      def update
        @dining_place = DiningPlace.find(params[:id])
        @dining_place.update_attributes(dining_place_update_params)
      end

      def destroy
        @dining_place = DiningPlace.find(params[:id]).destroy
      end

      private

        def dining_place_create_params
          params.require(:dining_place).permit(:institution_id, :name, :details_link, :gps_longitude, :gps_latitude, :range, :dining_period_id, :menu_item_id)
        end

        def dining_place_update_params
          params.require(:dining_place).permit(:institution_id, :name, :details_link, :gps_longitude, :gps_latitude, :range)
        end
    end
  end
end
