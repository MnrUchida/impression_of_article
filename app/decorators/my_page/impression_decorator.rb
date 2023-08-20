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

        #{article_title} #{article_url}?ref=twitter ##{article_nico_code} #ニコニコ動画 #おどれびゅ

        #{detail}
      EOS
    end

    def for_mastodon
      decorated_summary = <<~EOS
        #{article_title} ##{article_nico_code} #ニコニコ動画 #おどれびゅ #踊ってみた

        #{article_url}

        #{summary}

        #{detail}
      EOS

      {
        "status": decorated_summary,
        "visibility": "public"
      }
    end

    def for_note
      <<~EOS
        #{article_title}
  
        #{summary}
        #{detail}
        #{article_url}
      EOS
    end
  end
end
