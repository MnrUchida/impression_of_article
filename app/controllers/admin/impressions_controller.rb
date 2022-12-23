module Admin
  class ImpressionsController < ApplicationController
    before_action :set_impressions
    before_action :set_impression, except: :index

    def index
      @impressions = @impressions.page(params[:page]).per(10)
    end

    def show; end

    def destroy
      @impression.destroy!
      redirect_to admin_impressions_path, notice: "削除しました"
    end

    private

      def set_impression
        @impression = @impressions.find(params[:id])
      end

      def set_impressions
        @impressions = Impression.preload(:article, :user).order(created_at: :desc, id: :asc)
      end
  end
end
