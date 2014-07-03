module Api
  module V1
    class MenuItemsController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]
      respond_to :json

      def index
        if params[:dining_period_id]
          @menu_items = DiningPeriod.find(params[:dining_period_id]).menu_items
        elsif params[:dining_place_id]
          @menu_items = DiningPlace.find(params[:dining_place_id]).menu_items
        else
          @menu_items = specific_index(MenuItem, :institution_id)
        end
      end

      def show
        if params[:dining_period_id]
          @menu_items = DiningPeriod.find(params[:dining_period_id]).menu_items.find(params_id)
        elsif params[:dining_place_id]
          @menu_items = DiningPlace.find(params[:dining_place_id]).menu_items.find(params_id)
        else
          @menu_item = specific_show(MenuItem, :institution_id)
        end
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
          params.require(:menu_item).permit(:name, :institution_id, :dining_place_id, :dining_period_id, :details_link, :small_price, :large_price, :combo_price)
        end

        def menu_item_update_params
          params.require(:menu_item).permit(:name, :institution_id, :details_link, :small_price, :large_price, :combo_price)
        end
    end
  end
end
