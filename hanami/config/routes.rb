# frozen_string_literal: true

module Cast
  class Routes < Hanami::Routes
    # Add your routes here. See https://hanakai.org/learn/hanami/routing/ for details.
    root to: "home.index"
  end
end
