module ApplicationHelper
  def show_article_image(article)
    render(partial: "shared/article_image", locals: { article: article })
  end
end
