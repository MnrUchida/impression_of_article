require 'open-uri'

# == Schema Information
#
# Table name: articles
#
#  id                 :bigint           not null, primary key
#  content_type       :string
#  image_data         :binary
#  image_url          :string
#  note               :text
#  title              :string           not null
#  uploaded_image_url :string
#  url                :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
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
  has_many :published_tags, through: :published_impressions, source: :tags, class_name: 'Tag'

  validates :title, presence: true
  validates :url, presence: true

  after_save :set_actors!
  after_save :set_musics!

  # before_save :set_image, if: :will_save_change_to_image_url?
  # after_save :upload_s3, if: :saved_change_to_image_url?

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

  def reset_from_url
    html = URI.open(self.url).read
    parsed = Nokogiri.parse(html)
    self.title = parsed.css('meta[property="og:title"]').attribute('content').value
    self.image_url = parsed.css('meta[property="og:image"]').attribute('content').value
  end

  def set_actors!
    @actor_ids ||= actor_articles.pluck(:creator_id)
    transaction do
      exist_ids = actor_articles.pluck(:creator_id)
      actor_articles.reject { |actor_article| @actor_ids.include? actor_article.creator_id }.each(&:destroy!)
      @actor_ids.reject { |actor_id| exist_ids.include? actor_id }.each { |actor_id| actor_articles.create!(creator_id: actor_id) }
    end
  end

  def set_musics!
    @music_ids ||= music_articles.pluck(:music_id)
    transaction do
      exist_ids = music_articles.pluck(:music_id)
      music_articles.reject { |music_article| @music_ids.include? music_article.music_id }.each(&:destroy!)
      @music_ids.reject { |music_id| exist_ids.include? music_id }.each { |music_id| music_articles.create!(music_id: music_id) }
    end
  end

  def set_image
    URI.open(self.image_url) do |f|
      self.image_data = f.read
      self.content_type = f.content_type
    end
  end

  def upload_s3
    Tempfile.open(mode: File::RDWR, binmode: true) do |tempfile|
      tempfile.write(URI.open(self.image_url).read)
      tempfile.flush
      IMAGE_S3.object("article_image/#{self.id}").upload_file(tempfile.path)
    end
  end

  # def s3_url
  #   IMAGE_S3.object("article_image/#{self.id}").presigned_url(:get, expires_in: 604800)
  # end

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
