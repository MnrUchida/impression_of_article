module NicoUrlParser
  extend ActiveSupport::Concern

  module ClassMethods
    def nico?(url)
      url.include?("nicovideo.jp") || url.include?("nico.ms")
    end

    def nico_code(url)
      URI.parse(url).path.split('/').last
    end
  end

  def nico?
    self.class.nico?(self.url)
  end

  def nico_code
    self.class.nico_code(self.url)
  end
end
