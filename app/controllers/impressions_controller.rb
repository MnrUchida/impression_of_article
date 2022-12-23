class ImpressionsController < ApplicationController
  before_action :set_impressions

  def index
    @impressions = if search_params[:keyword].present?
                     @impressions.article_keyword_like(search_params[:keyword]).page(params[:page]).per(5)
                   else
                     @impressions = RandomizedImpression.preload(:article).page(1).per(100)
                   end
  end

  def show
    @impression = ImpressionDecorator.decorate(Impression.published.find(params[:id]))
  end

  private def set_impressions
    @impressions = Impression.published.preload(:article).order(created_at: :desc, id: :asc)
  end

  private def search_params
    params.fetch(:search, {}).permit(:keyword)
  end
end
