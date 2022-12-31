class ImpressionsController < ApplicationController
  before_action :set_impressions

  def index
    @tags = Tag.where(id: params[:tag_ids])
    if search_params[:keyword].present? || search_params[:full_text].present?
      page = params[:page]
      per_page = 5
      @impressions = @impressions.by_tag_ids(params[:tag_ids])
      @impressions = @impressions.article_keyword_like(search_params[:keyword]) if search_params[:keyword].present?
      @impressions = @impressions.keyword_like(search_params[:full_text]) if search_params[:full_text].present?
    else
      page = 1
      per_page = 100
      @impressions = RandomizedImpression.by_tag_ids(params[:tag_ids])
    end
    @impressions = @impressions.joins(:user).merge(User.only_show_name).where(user_id: search_params[:writer]) if search_params[:writer].present?
    @impressions = @impressions.preload(:article, :user, :tags).page(page).per(per_page)
  end

  def show
    @impression = Impression.published.find(params[:id])
    @article = @impression.article
    @other_impressions = @article.published_impressions.where.not(id: params[:id])
  end

  private def set_impressions
    @impressions = Impression.published.order(created_at: :desc, id: :asc)
  end

  private def search_params
    params.fetch(:search, {}).permit(:keyword, :writer, :full_text)
  end
end
