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
  include UrlParser

  attr_writer :actor_ids, :music_ids

  has_many :actor_articles, -> { actor }, dependent: :destroy, inverse_of: :article, class_name: 'CreatorArticle'
  has_many :cinematographer_articles, -> { cinematographer }, dependent: :destroy, inverse_of: :article, class_name: 'CreatorArticle'
  has_many :editor_articles, -> { editor }, dependent: :destroy, inverse_of: :article, class_name: 'CreatorArticle'
  has_many :music_articles, dependent: :destroy, inverse_of: :article
  has_many :impressions, dependent: :destroy, inverse_of: :article
  has_many :published_impressions, -> { published }, class_name: 'Impression'

  after_save :set_actors!
  after_save :set_musics!

  scope :keyword_like, ->(keyword) { title_like(keyword).or(creator_name_like(keyword)) }
  scope :title_like, ->(title) { where("title ILIKE :title", title: "%#{title}%") }
  scope :creator_name_like, lambda { |name|
    sql = <<~SQL
      EXISTS (
            SELECT 1 
              FROM creators
        INNER JOIN creator_articles
                ON creators.id = creator_articles.creator_id
             WHERE creators.name ILIKE :name
               AND creator_articles.article_id = articles.id
      )
    SQL
    where(sanitize_sql_array([sql, { name: "%#{name}%" }]))
  }
  scope :has_published_impressions, lambda {
    sql = <<~SQL
      EXISTS (
            SELECT 1 
              FROM impressions
             WHERE impressions.article_id = articles.id
               AND impressions.status = :status
      )
    SQL
    where(sanitize_sql_array([sql, { status: Impression.statuses[:published] }]))
  }

  def self.find_or_initialize_by_url(url)
    article = _find_by_url(url)
    return article if article.present?

    _find_or_initialize_by_url(url) do |article, parsed|
      article.title = article.title.presence || parsed.css('meta[property="og:title"]').attribute('content').value
      article.image_url = article.image_url.presence || parsed.css('meta[property="og:image"]').attribute('content').value
    end
  end

  def set_actors!
    @actor_ids ||= actor_articles.ids
    transaction do
      exist_ids = actor_articles.ids
      actor_articles.reject { |actor_article| @actor_ids.include? actor_article.creator_id }.each(&:destroy!)
      @actor_ids.reject { |actor_id| exist_ids.include? actor_id }.each { |actor_id| actor_articles.create!(creator_id: actor_id) }
    end
  end

  def set_musics!
    @music_ids ||= music_articles.ids
    transaction do
      exist_ids = music_articles.ids
      music_articles.reject { |music_article| @music_ids.include? music_article.music_id }.each(&:destroy!)
      @music_ids.reject { |music_id| exist_ids.include? music_id }.each { |music_id| music_articles.create!(music_id: music_id) }
    end
  end

  class << self
    private def _find_by_url(url)
      url = nico_url(url) if nico?(url)
      Article.find_by(url: url)
    end

    private def nico_url(url)
      "https://www.nicovideo.jp/watch/#{nico_code(url)}"
    end
  end
end
