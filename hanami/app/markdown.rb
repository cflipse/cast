require "kramdown"

module Cast
  class Markdown
    include Hanami::View::Helpers::EscapeHelper

    def to_html(input)
          escape_html(input)
            .then { |md| Kramdown::Document.new md }
            .then { |md| raw md.to_html }
    end
  end
end
