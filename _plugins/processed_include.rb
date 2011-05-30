class BetterInclude < Jekyll::IncludeTag
  def initialize(tag_name, file, tokens)
    super
    @file = file.strip
  end

  def render(context)
    context.registers[:site].converters.find do |c|
      c.matches(@file)
    end.convert(super)
  end
end

Liquid::Template.register_tag('include', BetterInclude)
