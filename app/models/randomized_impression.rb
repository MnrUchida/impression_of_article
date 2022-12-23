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

  delegate :url, :title, :nico_code, :nico?, :image_url, to: :article, allow_nil: true, prefix: true

  def readonly?
    true
  end
end
