class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  delegate :tag, :safe_join, :link_to, to: :@template

  def label(method, text = nil, **opts, &)
    classes = opts.delete(:class).to_s.split(" ")
    classes << "pt-2" unless classes.any? { |c| c =~ /^pt?-/ }
    classes << "font-bold"
    classes << "whitespace-nowrap"
    classes << "justify-self-end" unless classes.any? { |c| c =~ /justify-self/ }

    super(method, text, class: classes.join(" "), **opts, &)
  end

  def grid(&)
    tag.div(class: "grid grid-cols-[fit-content(10rem)_minmax(30rem,1fr)] gap-3", &)
  end

  def stack(&)
    tag.div(class: "flex flex-col", &)
  end

  def actions(&)
    safe_join([tag.div, tag.div(&)])
  end

  def submit(text = nil, **opts)
    classes ||= opts.delete(:class).to_s.split(" ")

    classes << "bg-amber-700"
    classes << "p-4" unless classes.any? { |c| c =~ /^p.?-/ }
    classes << "rounded-md"
    classes << "text-gray-300"
    classes << "font-bold"

    super(text, class: classes.join(" "), **opts)
  end

  def cancel path
    link_to "Cancel", path, class: "bg-gray-300 ml-2 p-5 rounded-md font-bold"
  end
end
