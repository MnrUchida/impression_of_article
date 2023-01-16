class ArticlesController < ApplicationController
  def show
    @article = Article.has_published_impressions.find(params[:id])
    send_data(@article.image_data, { filename: "image_data_#{@article.id}", type: @article.content_type, disposition: :inline })
  end
end
