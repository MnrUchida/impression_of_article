# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  content    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  has_many :impression_tags, dependent: :destroy, inverse_of: :tag
  has_many :impressions, through: :impression_tags, inverse_of: :tags

  scope :order_by_count, lambda { |user_id|
    sql = <<~SQL
      SUM(CASE WHEN impressions.user_id = :user_id THEN 1 ELSE 0 END) DESC,
      COUNT(*) DESC
    SQL
    left_joins(impression_tags: :impression).group(Tag.column_names).order(Arel.sql(sanitize_sql_array([sql, { user_id: user_id }])))
  }
  scope :content_like, ->(keyword) { where("content ILIKE :keyword", keyword: "%#{keyword}%") }
end
