module Api
  module V1
    class DepartmentsController < ApplicationController #Api::BaseController

      # before_action :authenticate_admin_user!, :only => [:create, :update, :destroy]
      # before_action => :confirm_admin, :only => [:create, :update, :destroy]

      respond_to :json

      def index
        @departments = specific_index(Department, params)
      end

      def show
        @department = specific_show(Department,params[:id])
      end

      def create
        @department = Department.create(department_params)
      end

      def update
        @department = Department.find(params[:id])
        @department.update_attributes(department_params)
      end

      def destroy
        @department = Department.find(params[:id]).destroy
      end

      private

        def department_params
          params.require(:department).permit(:name, :institution_id)
        end
    end
  end
end
