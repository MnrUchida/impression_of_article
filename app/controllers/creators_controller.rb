class CreatorsController < ApplicationController
  def index
    @creators = Creator.has_published_impressions
    @creators = @creators.name_like(search_params[:keyword]) if search_params[:keyword].present?
    @creators = @creators.preload(:creator_articles).page(params[:page]).per(7)
  end

  def show
    @creator = Creator.find(params[:id])
    @articles = @creator.articles.has_published_impressions
    @articles = @articles.title_like(search_params[:keyword]) if search_params[:keyword].present?
    @articles = @articles.preload(:published_impressions).page(params[:page]).per(5)
  end

  private def search_params
    params.fetch(:search, {}).permit(:keyword)
  end
end
