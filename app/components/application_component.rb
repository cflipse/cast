class ApplicationComponent < ViewComponent::Base
  delegate :icon, to: :helpers
end
