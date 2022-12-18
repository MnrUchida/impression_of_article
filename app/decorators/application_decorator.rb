class ApplicationDecorator < Draper::Decorator
  delegate_all

  delegate :model_name, to: :object
end
