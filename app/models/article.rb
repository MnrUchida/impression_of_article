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
  has_many :actor_articles, -> { actor }, dependent: :destroy, inverse_of: :article, class_name: 'CreatorArticle'
  has_many :actors, through: :actor_articles, class_name: 'Creator'

  has_many :cinematographer_articles, -> { cinematographer }, dependent: :destroy, inverse_of: :article, class_name: 'CreatorArticle'
  has_many :cinematographers, through: :cinematographer_articles, class_name: 'Creator'

  has_many :editor_articles, -> { editor }, dependent: :destroy, inverse_of: :article, class_name: 'CreatorArticle'
  has_many :editors, through: :editor_articles, class_name: 'Creator'

  def self.find_or_initialize_by_url(url)
    url = File.join(Rails.root, 'tmp/hoge.html')
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

  def nico?
    self.url.include?("www.nicovideo.jp")
  end

  def nico_code
    URI.parse(self.url).path.split('/').last
  end
end
