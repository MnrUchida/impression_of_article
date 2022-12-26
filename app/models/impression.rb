# == Schema Information
#
# Table name: impressions
#
#  id         :bigint           not null, primary key
#  detail     :text
#  status     :integer
#  summary    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_impressions_on_article_id  (article_id)
#  index_impressions_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
class Impression < ApplicationRecord
  TAG_LIMIT = 10

  belongs_to :user
  belongs_to :article
  has_many :impression_tags, dependent: :destroy, inverse_of: :impression
  has_many :tags, through: :impression_tags, inverse_of: :impression

  validates :summary, presence: true

  delegate :url, :title, :nico_code, :nico?, :image_url, to: :article, allow_nil: true, prefix: true

  enum status: { pending: 0, published: 1 }
  scope :article_keyword_like, ->(keyword) { joins(:article).merge(Article.keyword_like(keyword)) }
  scope :by_tag_ids, lambda { |tag_ids|
    return all if tag_ids.blank?

    sql = <<~SQL
      EXISTS (
            SELECT 1 
              FROM impression_tags
             WHERE impression_tags.tag_id IN (:tag_ids)
               AND impression_tags.impression_id = impressions.id
      )
    SQL
    where(sanitize_sql_array([sql, { tag_ids: tag_ids }]))
  }

  def entry_type=(value)
    self.status = value.to_sym == :pending ? :pending : :published
  end

  def create_tags!(tag_contents)
    tag_contents.split(' ').each do |tag_content|
      tag = Tag.find_or_initialize_by(content: tag_content)
      add_tag!(tag)
    end
  end

  def add_tag!(tag)
    return if impression_tags.length >= TAG_LIMIT
    return if impression_tags.exists?(tag: tag)

    impression_tags.create!(tag: tag)
  end
end
