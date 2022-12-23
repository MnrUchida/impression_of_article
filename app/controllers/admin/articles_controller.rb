module Admin
  class ArticlesController < ApplicationController
    before_action :set_article, only: %i[show edit update destroy]

    def index
      @articles = Article.preload(actor_articles: :creator, music_articles: :music).page(params[:page])
    end

    def show; end

    def edit; end

    def update
      @article.attributes = article_params
      if @article.save
        redirect_to admin_article_url(@article), notice: "Article was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
      def set_article
        @article = Article.preload(actor_articles: :creator, music_articles: :music).find(params[:id])
      end

      def article_params
        params.require(:article).permit(:note, :title, :url, :image_url, actor_ids: [], music_ids: [])
      end
  end
end
