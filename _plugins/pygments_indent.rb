class BetterHighlightBlock < Jekyll::HighlightBlock
  def render_pygments(context, code)
    code = code.join if code.respond_to?(:join)

    # Remove leading tabs
    while !code.index(/\n(?!\t)/)
      code = code.gsub("\n\t", "\n")
    end

    # Convert remaining tabs to spaces
    tab_width = context['tab-width'] || 4
    code = code.gsub("\t", ' ' * tab_width)

    # Actually render the thing
    result = super(context, code)

    # Fix a bug for when embedded in blockquotes.
    result.gsub("</pre>\n</div>\n", '</pre></div> ')
  end
end

Liquid::Template.register_tag('highlight', BetterHighlightBlock)

