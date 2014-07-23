module Api
  module V1
    class MenuItemsController < ApplicationController #Api::BaseController

      # before_action => :confirm_admin, :only => [:create, :update, :destroy]
      
      respond_to :json

      def index
        @menu_items = specific_index(MenuItem, params)
      end

      def show
        @menu_item = specific_show(MenuItem, params[:id])
      end

      def create
        @menu_item = MenuItem.create(menu_item_params)
      end

      def update
        @menu_item = MenuItem.find(params[:id])
        @menu_item.update_attributes(menu_item_params)
      end

      def destroy
        @menu_item = MenuItem.find(params[:id]).destroy
      end

      private

        def menu_item_params
          params.require(:menu_item).permit(:name, :institution_id, :category, :details_link, :small_price, :large_price, :combo_price, :dining_opportunity_id, :dining_place_id, :date_available)
        end

    end
  end
end
