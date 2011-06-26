class BetterHighlightBlock < Jekyll::HighlightBlock
  def render_pygments(context, code)
    while !code.index(/\n(?!\t)/)
      code = code.gsub("\n\t", "\n")
    end
    tab_width = context['tab-width']
    tab_width = 4 if tab_width.nil?
    super(context, code.gsub("\t", ' ' * tab_width))
  end
end

Liquid::Template.register_tag('highlight', BetterHighlightBlock)

