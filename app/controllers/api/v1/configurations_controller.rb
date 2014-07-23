module Api
  module V1
    class ConfigurationsController < ApplicationController #Api::BaseController

      # before_action => :confirm_admin, :only => [:create, :update, :destroy]

      respond_to :json

      # Have to use ::Configuration to resolve ambiguity with namespace.
      def index
        @configurations = ::Configuration.all
      end

      def show
        @configuration = specific_show(::Configuration,params[:id])
      end

      def create
        @configuration = ::Configuration.create(configuration_params)
      end

      def update
        @configuration = ::Configuration.find(params[:id])
        @configuration.update_attributes(configuration_params)
      end

      def destroy
        @configuration = ::Configuration.find(params[:id]).destroy
      end

      private

        def configuration_params
          params.require(:configuration).permit(:mascot, :config_file_name)
        end
    end
  end
end
