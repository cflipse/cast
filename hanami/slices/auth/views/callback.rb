# frozen_string_literal: true

module Auth
  module Views
    class Callback < Auth::View
      expose :result
      expose(:profile) { |result:| result.success? ? result.value! : nil }
      expose(:failure) { |result:| result.failure? ? result.failure.inspect : nil }
    end
  end
end
