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

  def readonly?
    true
  end
end
