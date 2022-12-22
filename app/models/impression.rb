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
  belongs_to :user
  belongs_to :article

  validates :summary, presence: true

  delegate :url, :title, :nico_code, :nico?, to: :article, allow_nil: true, prefix: true

  enum status: { pending: 0, published: 1 }
  scope :article_keyword_like, ->(keyword) { joins(:article).merge(Article.keyword_like(keyword)) }
end
