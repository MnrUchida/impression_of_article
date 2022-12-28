module Creators
  class ArticlesController < ApplicationController
    before_action :set_creator

    def show
      @article = @creator.articles.find(params[:id])
      @impressions = @article.published_impressions
    end

    private def set_creator
      @creator = Creator.find(params[:creator_id])
    end
  end
end
