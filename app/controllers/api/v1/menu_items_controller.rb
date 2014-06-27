module Api
  module V1
    class MenuItemsController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @menu_items = MenuItem.all
    end

    def show
      @menu_item = MenuItem.find(params[:id])
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

        params.require(:menu_item).permit(:name, :institution_id, :dining_place_id, :dining_period_id, :details_link, :small_price, :large_price, :combo_price)

      end
    end
  end
end
