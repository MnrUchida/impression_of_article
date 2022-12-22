class ImpressionsController < ApplicationController
  before_action :set_impressions

  def index
    @impressions = @impressions.article_title_like(search_params[:keyword])
    @impressions = @impressions.page(params[:page]).per(5)
  end

  def show
  end

  private def set_impressions
    @impressions = Impression.published.preload(:article).order(created_at: :desc, id: :asc)
  end

  private def search_params
    params.fetch(:search, {}).permit(:keyword)
  end
end
