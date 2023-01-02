module Admin
  module Shared
    class CreatorsController < ApplicationController
      before_action :set_creator, only: %i[update destroy]

      def index
        @creators = Creator.order_by_name
        @creators = @creators.where("name LIKE :name", name: "%#{search_params[:name]}%")
        @creators = @creators.page(params[:page])
      end

      def new
        @creator = Creator.new
      end

      def create
        @creator = Creator.new(creator_params)
        render :new, status: :unprocessable_entity unless @creator.save
      end

      def update; end

      def destroy; end

      private
        def creator_params
          params.require(:creator).permit(:name, :url)
        end

        def search_params
          params.fetch(:search, {}).permit(:name)
        end

        def set_creator
          @creator = Creator.find(params[:id])
        end
    end
  end
end
