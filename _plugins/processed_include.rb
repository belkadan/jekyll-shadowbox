class BetterInclude < Jekyll::IncludeTag
  def render(context)
    context.registers[:site].converters.find do |c|
      c.matches(@file)
    end.convert(super)
  end
end

class IfIncludeExists < Liquid::Block
  SYNTAX = /[\w\/\.-]+/
  
  def initialize(tag_name, file, tokens)
    if file !~ SYNTAX
      raise SyntaxError.new("Syntax Error in 'if_include_exists' - Valid syntax: if_include_exists file.ext")
    elsif file =~ /\.\// or file =~ /\/\./
      raise SyntaxError.new("Syntax Error in 'if_include_exists' - filename contains invalid characters")
    else
      super
      @file = file.strip
    end
  end
  
  def unknown_tag(tag, markup, tokens)
    if tag == 'else'
      @before_else = @nodelist
      @after_else = @nodelist = []
    else
      super
    end
  end

  def block_delimiter
    'end_include_exists'
  end
  
  def render(context)
    context.stack do
      includes_dir = File.join(context.registers[:site].source, '_includes')
    
      @before_else ||= @nodelist
      @after_else ||= []
    
      Dir.chdir(includes_dir) do
        if File.file?(@file)
          return render_all(@before_else, context)
        else
          return render_all(@after_else, context)
        end
      end
    end
  end
end

Liquid::Template.register_tag('include', BetterInclude)
Liquid::Template.register_tag('if_include_exists', IfIncludeExists)
