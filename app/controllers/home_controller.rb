class HomeController < ApplicationController

  def index
    @impressions = RandomizedImpression.preload(:article)
    @impressions = @impressions.page(params[:page]).per(5)
  end
end
