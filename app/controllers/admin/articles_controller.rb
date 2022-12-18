module Admin
  class ArticlesController < ApplicationController
    before_action :set_article, only: %i[show edit update destroy]

    def index
      @articles = Article.page(params[:page])
    end

    def show
    end

    def edit
    end

    def new
      @article = Article.new
    end

    def update
      @article.attributes = article_params
      if @article.save
        redirect_to admin_article_url(@article), notice: "Article was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def create
      @article = Article.new(article_params)
      @article.set_article_from_url
      respond_to do |format|
        if @article.save
          redirect_to admin_article_url(@article), notice: "Article was successfully updated."
        else
          render :new, status: :unprocessable_entity
        end
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:note, :title, :url, :image_url)
    end
  end
end
