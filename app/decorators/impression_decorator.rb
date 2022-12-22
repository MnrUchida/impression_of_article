class ImpressionDecorator < ApplicationDecorator
  def combined
    <<~TEXT
      #{summary}

      #{detail}
    TEXT
  end
end
