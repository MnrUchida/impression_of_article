# == Schema Information
#
# Table name: randomized_impressions
#
#  id         :bigint
#  detail     :text
#  status     :integer
#  summary    :string
#  created_at :datetime
#  updated_at :datetime
#  article_id :bigint
#  user_id    :bigint
#
class RandomizedImpression < ApplicationRecord
  belongs_to :user
  belongs_to :article
  has_many :impression_tags, dependent: :destroy, inverse_of: :impression, foreign_key: :impression_id, primary_key: :id
  has_many :tags, through: :impression_tags, inverse_of: :impressions

  delegate :url, :title, :nico_code, :nico?, :image_url, to: :article, allow_nil: true, prefix: true
  delegate :name, :show_name?, to: :user, prefix: true

  scope :by_tag_ids, lambda { |tag_ids|
    return all if tag_ids.blank?

    sql = <<~SQL
      EXISTS (
            SELECT 1 
              FROM impression_tags
             WHERE impression_tags.tag_id IN (:tag_ids)
               AND impression_tags.impression_id = randomized_impressions.id
      )
    SQL
    where(sanitize_sql_array([sql, { tag_ids: tag_ids }]))
  }

  def readonly?
    true
  end
end
