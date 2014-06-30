module Api
  module V1
    class DepartmentsController < ApplicationController #Api::BaseController

    # before_action :confirm_admin
    # :except => [:index, :show]

    respond_to :json

    def index
      @departments = institution_index(Department)
    end

    def show
      @department = institution_show(Department)
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
