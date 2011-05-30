class BetterHighlightBlock < Jekyll::HighlightBlock
  def render_pygments(context, code)
    while !code.index(/\n(?!\t)/)
      code = code.gsub("\n\t", "\n")
    end
    super(context, code)
  end
end

Liquid::Template.register_tag('highlight', BetterHighlightBlock)

