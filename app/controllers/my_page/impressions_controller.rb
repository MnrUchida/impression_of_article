module MyPage
  class ImpressionsController < ApplicationController
    before_action :set_impression, only: %i[show edit update destroy publish]

    def index
      @impressions = Impression.preload(:article).where(user: current_user)
      @impressions = @impressions.where(status: params[:status])
      @impressions = @impressions.page(params[:page]).per(5)
    end

    def new
      @impression = Impression.new
    end

    def show
      @decorated_impression = ImpressionDecorator.decorate(@impression)
    end

    def edit; end

    def update
      @impression.attributes = impression_params
      @impression.user = current_user
      @impression.status = :pending
      if @impression.save
        redirect_to my_page_impression_url(@impression), notice: "更新しました"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def create
      @impression = Impression.new(impression_params)
      @impression.user = current_user
      @impression.status = :pending
      if @impression.save
        redirect_to my_page_impression_url(@impression), notice: "登録しました"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update_article
      @article = Article.find_or_initialize_by_url(params[:url])
      @article.save if @article.present?
    end

    def publish
      @impression.published!
      redirect_to my_page_impressions_url(status: :published)
    end

    private

      def set_impression
        @impression = Impression.find(params[:id])
      end

      def impression_params
        params.require(:impression).permit(:detail, :summary, :article_id)
      end
  end
end
