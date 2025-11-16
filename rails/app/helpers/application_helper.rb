module ApplicationHelper
  def markdown(text)
    sanitize(text.to_s)
      .then(&Kramdown::Document.method(:new))
      .to_html
      .html_safe
  end

  def icon(name, **args)
    css = args.delete(:class)
    css = ["bi-#{name}", css].compact.join
    tag.i(class: css, **args)
  end
end
