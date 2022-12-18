# == Schema Information
#
# Table name: creators
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  note       :text
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Creator < ApplicationRecord
  has_many :music_creators, dependent: :destroy, inverse_of: :creator
  has_many :musics, through: :music_creators
end
