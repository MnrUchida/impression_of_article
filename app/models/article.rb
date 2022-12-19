require 'open-uri'

# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  image_url  :string
#  note       :text
#  title      :string           not null
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Article < ApplicationRecord
  include NicoUrlParser

  has_many :actor_articles, -> { actor }, dependent: :destroy, inverse_of: :article, class_name: 'CreatorArticle'
  has_many :actors, through: :actor_articles, class_name: 'Creator'

  has_many :cinematographer_articles, -> { cinematographer }, dependent: :destroy, inverse_of: :article, class_name: 'CreatorArticle'
  has_many :cinematographers, through: :cinematographer_articles, class_name: 'Creator'

  has_many :editor_articles, -> { editor }, dependent: :destroy, inverse_of: :article, class_name: 'CreatorArticle'
  has_many :editors, through: :editor_articles, class_name: 'Creator'

  scope :title_like, ->(title) { where("title ILIKE :title", title: "%#{title}%") }

  def self.find_or_initialize_by_url(url)
    article = _find_by_url(url)
    article || _find_or_initialize_by_url(url)
  end

  class << self
    private def _find_or_initialize_by_url(url)
      html = URI.open(url).read
      parsed = Nokogiri.parse(html)
      adjusted_url = parsed.css('meta[property="og:url"]').attribute('content').value
      article = Article.find_or_initialize_by(url: adjusted_url)
      if article.new_record?
        article.title = article.title.presence || parsed.css('meta[property="og:title"]').attribute('content').value
        article.image_url = article.image_url.presence || parsed.css('meta[property="og:image"]').attribute('content').value
      end
      article
    rescue => e
    end

    private def _find_by_url(url)
      url = nico_url(url) if nico?(url)
      Article.find_by(url: url)
    end
  end
end
