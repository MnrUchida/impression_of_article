module Admin
  class UsersController < ApplicationController
    before_action :set_creator, only: %i[show edit update destroy]

    def index
      @creators = Creator.all
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
  end
end
