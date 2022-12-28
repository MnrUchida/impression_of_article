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
  include NicoUrlParser
  include UrlParser

  has_many :music_articles, dependent: :destroy, inverse_of: :music
  has_many :articles, inverse_of: :musics
  has_many :music_creators, dependent: :destroy, inverse_of: :music
  has_many :creators, inverse_of: :musics

  validates :title, presence: true
  validates :url, presence: true

  def self.find_or_initialize_by_url(url)
    music = _find_by_url(url)
    return music if music.present?

    _find_or_initialize_by_url(url) do |music, parsed|
      music.title = music.title.presence || parsed.css('meta[property="og:title"]').attribute('content').value
      music.image_url = music.image_url.presence || parsed.css('meta[property="og:image"]').attribute('content').value
    end
  end

  class << self
    private def _find_by_url(url)
      url = nico_url(url) if nico?(url)
      Music.find_by(url: url)
    end

    private def nico_url(url)
      "https://www.nicovideo.jp/watch/#{nico_code(url)}"
    end
  end
end
