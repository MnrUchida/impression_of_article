class CreatorsController < ApplicationController
  before_action :set_search_params

  def index
    @creators = Creator.has_published_impressions.order(Arel.sql("random()"))
    @creators = @creators.name_like(search_params[:keyword]) if search_params[:keyword].present?
    @impressions = impressions_by_creator
  end

  def show
    @creator = Creator.find(params[:id])
    @articles = @creator.articles.has_published_impressions
    @articles = @articles.title_like(search_params[:keyword]) if search_params[:keyword].present?
    @articles = @articles.preload(:published_tags).page(params[:page]).per(5)
  end

  private def set_search_params
    @search_params = search_params
  end

  private def search_params
    params.fetch(:search, {}).permit(:keyword)
  end

  private def impressions_by_creator
    randomized_with_creator = Impression.randomized_with_creator
    impressions = Impression.published.where(id: randomized_with_creator.map(&:id)).preload(:article).index_by(&:id)
    randomized_with_creator.to_h { |randomized_impression| [randomized_impression.creator_id, impressions[randomized_impression.id]] }
  end
end
