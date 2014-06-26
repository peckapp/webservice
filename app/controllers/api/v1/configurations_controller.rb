module Api
  module V1
    class ConfigurationsController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @configurations = Configuration.all
    end

    def show
      @configuration = Configuration.find(params[:id])
    end

    def create
      @configuration = Configuration.create(configuration_params)
    end

    def update
      @configuration = Configuration.find(params[:id])
      @configuration.update_attributes(configuration_params)
    end

    def destroy
      @configuration = Configuration.find(params[:id]).destroy
    end

    private

      def configuration_params
        params.require(:configuration).permit(:mascot, :config_file_name, :created_at, :updated_at)
      end
    end
  end
end
