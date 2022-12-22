module UrlParser
  extend ActiveSupport::Concern

  module ClassMethods
    def _find_or_initialize_by_url(url)
      html = URI.open(url).read
      parsed = Nokogiri.parse(html)
      adjusted_url = parsed.css('meta[property="og:url"]').attribute('content').value
      record = self.find_or_initialize_by(url: adjusted_url)
      yield(record, parsed) if record.new_record?
      record
    rescue => e
    end
  end
end
