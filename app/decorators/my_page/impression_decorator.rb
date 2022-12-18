module MyPage
  class ImpressionDecorator < ApplicationDecorator
    def combined
      <<~TEXT
        #{summary}
        #{detail}
      TEXT
    end

    def for_twitter
      <<~EOS
        #{summary}

        #{article_title} #{article_url}?ref=twitter ##{article_nico_code} #ニコニコ動画

        #{detail}
      EOS
    end

    def for_note
      <<~EOS
        ### #{article_title}
  
        #{combined}
        #{article_url}
      EOS
    end
  end
end
