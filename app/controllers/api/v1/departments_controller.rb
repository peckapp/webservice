module Api
  module V1
    class DepartmentsController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @departments = Department.all
    end

    def show
      @department = Department.find(params[:id])
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
