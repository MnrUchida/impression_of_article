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

  scope :order_by_count, -> { joins(:impression_tags).group(Tag.column_names).order(Arel.sql('COUNT(*) DESC')) }
  scope :content_like, ->(keyword) { where("content ILIKE :keyword", keyword: "%#{keyword}%") }
end
