module Api
  module V1
    class MenuItemsController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]
      respond_to :json

      def index
        @menu_items = specific_index(MenuItem, params)
      end

      def show
        @menu_item = specific_show(MenuItem, params)
      end

      def create
        @menu_item = MenuItem.create(menu_item_create_params)

        @dining_period_id = menu_item_create_params[:dining_period_id]
        DiningPeriod.find(@dining_period_id).menu_items << @menu_item

        @dining_place_id = menu_item_create_params[:dining_place_id]
        DiningPlace.find(@dining_place_id).menu_items << @menu_item
      end

      def update
        @menu_item = MenuItem.find(params[:id])
        @menu_item.update_attributes(menu_item_update_params)
      end

      def destroy
        @menu_item = MenuItem.find(params[:id]).destroy
      end

      private

        def menu_item_create_params
          params.require(:menu_item).permit(:name, :institution_id, :dining_place_id, :dining_period_id, :details_link, :small_price, :large_price, :combo_price, :dining_opportunity_id, :date_available)
        end

        def menu_item_update_params
          params.require(:menu_item).permit(:name, :institution_id, :details_link, :small_price, :large_price, :combo_price, :dining_opportunity_id, :date_available)
        end
    end
  end
end
