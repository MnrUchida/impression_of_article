module Admin
  class UsersController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy]

    def index
      @users = User.page(params[:page])
    end

    def new
      @user = User.new
    end

    def show; end

    def edit; end

    def update
      @user.attributes = user_params
      if @user.save
        redirect_to admin_user_url(@user), notice: "User was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_user_url(@user), notice: "User was successfully updated."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private
      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:email, :name, :password, :role)
      end
  end
end
