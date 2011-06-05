$: << File.dirname(__FILE__)
require 'truncate'

module ExtendedFilters

  def month_to_name(input)
    Date::MONTHNAMES[input]
  end

  def month_to_abbr(input)
    Date::ABBR_MONTHNAMES[input]
  end
  
  def pad(input, length = 2)
    ('%%0%dd' % length) % input 
  end

  def preview(text, delimiter = '<!--more-->')
    if text.index(delimiter) != nil
      text.split(delimiter).first
    elsif String.method_defined?(:truncate_html)
      text.truncate_html(100)
    else
      text # nothing we can do!
    end
  end
  
  def xml_id(input)
    input.to_s.to_xml_id
  end
  
  def taxonomy_name(input)
    input.to_s.taxonomy_name
  end
  
  def js_escape(input)
    input.gsub(/[^\w \`\/\[\]\(\)\*\^\%\$\#\@\!\~\{\}\?\|\:\;\,\.\-\_\+]/mu) {|s| '\u%04x' % s.unpack('U').first }
  end

end

class String
  def to_xml_id
    downcase.gsub('c++', 'cxx').gsub(/[\/\s]/, '-').gsub(/[^-\w]/, '')
  end
  
  def taxonomy_name
    # FIXME: needs to be more extensible...
    replacements = {
      'generictoolbar' => 'GenericToolbar',
      'gdb' => 'GDB',
      'javascript' => 'JavaScript',
      'os x' => 'OS X',
      'php' => 'PHP',
    }
    result = capitalize
    replacements.each do |before, after|
      result.gsub!(/\b#{before}\b/i, after)
    end
    
    # Special case for Objective-*
    result.gsub!(/\bobjective-([a-z]+)\b/i) {|_| "Objective-#{$1.capitalize}" }
    result
  end
end


Liquid::Template.register_filter(ExtendedFilters)
