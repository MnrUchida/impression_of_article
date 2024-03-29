module Admin
  class CreatorsController < ApplicationController
    before_action :set_creator, only: %i[show edit update]

    def index
      @creators = Creator.order_by_name
      @creators = @creators.name_like(search_params[:keyword]) if search_params[:keyword].present?
      @creators = @creators.page(params[:page])
    end

    def new
      @creator = Creator.new
    end

    def show
    end

    def edit; end

    def update
      @creator.attributes = creator_params
      if @creator.save
        redirect_to admin_creator_url(@creator), notice: "Creator was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def create
      @creator = Creator.new(creator_params)
      if @creator.save
        redirect_to admin_creator_url(@creator), notice: "Creator was successfully updated."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private
      def set_creator
        @creator = Creator.find(params[:id])
      end

      def creator_params
        params.require(:creator).permit(:note, :name, :url)
      end

      def search_params
        params.fetch(:search, {}).permit(:keyword)
      end
  end
end
