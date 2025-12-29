# auto_register: false
# frozen_string_literal: true

require "kramdown"

module Casts
  module Views
    module Helpers
      def markdown text
        escape_html(text)
          .then { |safe| Kramdown::Document.new(safe).to_html }
          .then { |html| raw(html) }
      end
    end
  end
end
