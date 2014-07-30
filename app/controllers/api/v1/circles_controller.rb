module Api
  module V1
    class CirclesController < ApplicationController #Api::BaseController

      before_action :confirm_logged_in

      # give circle admin power?
      respond_to :json

      def index

        @circles = specific_index(Circle, params)

        # hash mapping circle id to array of its members for display in json
        @member_ids = {}

        for c in @circles
          @member_ids[c.id] = CircleMember.where("circle_id" => c.id).pluck(:user_id)
        end
      end

      def show
        @circle = specific_show(Circle, params[:id])

        # array of this circle's members for display in json
        @member_ids = CircleMember.where("circle_id" => params[:id]).pluck(:user_id)
      end

      def create
        # all of the parameters in the circle
        cparams = params[:circle]

        # returns the array of circle member ids
        the_circle_members = cparams.delete(:circle_member_ids)

        # passes in the cparams to permit certain attributes
        @circle = Circle.create(circle_create_params(cparams))

        @member_ids = []

        if @circle
          # takes the array of circle members found in the circle block
          members = the_circle_members
          # members should be an array of integers corresponding to user ids
          members.each do |mem_id|
          # creates a circle member
            member = CircleMember.create(:institution_id => @circle.institution_id, :circle_id => @circle.id, :user_id => mem_id, :invited_by => @circle.user_id)

            # adds the member to the array of circle members for the created circle
            @circle.circle_members << member
          end

          # circle members
          circle_mems = @circle.circle_members

          circle_mems.each do |mem|
            @member_ids << mem.user_id
          end
        else
          @member_ids = nil
        end

        return @member_ids
      end

      def update
        @circle = Circle.find(params[:id])
        @circle.update_attributes(circle_update_params)
      end

      def destroy
        @circle = Circle.find(params[:id]).destroy
      end

      private

        def circle_create_params(parameters)
          parameters.permit(:institution_id, :user_id, :circle_name)
        end

        def circle_update_params
          params.require(:circle).permit(:institution_id, :user_id, :circle_name)
        end
    end
  end
end
