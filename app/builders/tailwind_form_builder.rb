class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  def label(method, text = nil, **opts, &block)
    classes = opts[:class].to_s.split(" ")
    classes << "font-bold"
    classes << "justify-self-end" unless classes.any? {|c| c =~ /justify-self/ }

    opts[:class] = classes.join(" ")

    super(method, text, opts, &block)
  end

  def text_field(method, **opts)
    super(method, opts)
  end
end
