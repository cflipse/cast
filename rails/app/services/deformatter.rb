class Deformatter
  include ActionView::Helpers::SanitizeHelper

  def call(text)
    markdown(text)
      .then { |html| sanitize(html) }
      .then { |html| demarkdown(html) }
      .then { |md| strip_tags(md) }
  end

  def markdown(text)
    Kramdown::Document.new(text).to_html
  end

  def demarkdown(html)
    Kramdown::Document.new(html, html_to_native: true, input: "html").to_kramdown
  end
end
