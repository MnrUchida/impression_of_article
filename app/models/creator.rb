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
  include NicoUrlParser
  include UrlParser

  has_many :creator_articles, dependent: :destroy, inverse_of: :creator
  has_many :articles, through: :creator_articles
  has_many :music_creators, dependent: :destroy, inverse_of: :creator
  has_many :musics, through: :music_creators

  def self.find_or_initialize_by_url(url)
    record = _find_by_url(url)
    return record if record.present?

    _find_or_initialize_by_url(url) do |creator, parsed|
      creator.name = creator.name.presence || parsed.css('meta[property="profile:username"]').attribute('content').value
    end
  end

  class << self
    private def _find_by_url(url)
      url = nico_url(url) if nico?(url)
      Creator.find_by(url: url)
    end

    private def nico_url(url)
      "https://www.nicovideo.jp/user/#{nico_code(url)}"
    end
  end
end
