# == Schema Information
#
# Table name: creator_articles
#
#  id         :bigint           not null, primary key
#  role       :integer          default("actor"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  creator_id :bigint           not null
#
# Indexes
#
#  index_creator_articles_on_article_id  (article_id)
#  index_creator_articles_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (creator_id => creators.id)
#
class CreatorArticle < ApplicationRecord
  enum role: { actor: 0, cinematographer: 1, editor: 2 }

  belongs_to :creator, inverse_of: :creator_articles
  belongs_to :article

  delegate :name, to: :creator, allow_nil: true, prefix: true
end
