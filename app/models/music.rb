# == Schema Information
#
# Table name: musics
#
#  id         :bigint           not null, primary key
#  image_url  :string
#  note       :text
#  title      :string           not null
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Music < ApplicationRecord
  has_many :music_creators, dependent: :destroy, inverse_of: :music
  has_many :creators, dependent: :destroy, inverse_of: :music
end
