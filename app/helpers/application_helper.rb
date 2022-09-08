module ApplicationHelper
  def markdown(text)
    sanitize(text.to_s)
      .then(&Kramdown::Document.method(:new))
      .to_html
      .html_safe
  end
end
