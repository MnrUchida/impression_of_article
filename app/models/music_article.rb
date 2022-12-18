# == Schema Information
#
# Table name: music_articles
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  music_id   :bigint           not null
#
# Indexes
#
#  index_music_articles_on_article_id  (article_id)
#  index_music_articles_on_music_id    (music_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (music_id => musics.id)
#
class MusicArticle < ApplicationRecord
  belongs_to :music, inverse_of: :music_articles
  belongs_to :article, inverse_of: :music_articles
end
