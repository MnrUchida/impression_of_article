# == Schema Information
#
# Table name: music_creators
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  creator_id :bigint           not null
#  music_id   :bigint           not null
#
# Indexes
#
#  index_music_creators_on_creator_id  (creator_id)
#  index_music_creators_on_music_id    (music_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => creators.id)
#  fk_rails_...  (music_id => musics.id)
#
class MusicCreator < ApplicationRecord
  belongs_to :music, inverse_of: :music_creators
  belongs_to :creator, inverse_of: :music_creators
end
