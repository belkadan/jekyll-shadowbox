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
  
  def resolve(input, base)
    if input.start_with? '/' then
      input
    else
      base + '/' + input
    end
  end

end

class String
  def to_xml_id
    downcase.gsub('c++', 'cxx').gsub(/[\/\s]/, '-').gsub(/[^-\w]/, '')
  end
  
  def taxonomy_name
    # FIXME: needs to be more extensible...
    special_cases = [
      'GDB',
      'GenericToolbar',
      'JavaScript',
      'OS X',
      'PHP',
      'TextMate'
    ]
    result = capitalize
    special_cases.each do |wd|
      result.gsub!(/\b#{wd}\b/i, wd)
    end
    
    # Special case for Objective-*
    result.gsub!(/\bobjective-([a-z]+)\b/i) {|_| "Objective-#{$1.taxonomy_name}" }
    result
  end
end


Liquid::Template.register_filter(ExtendedFilters)
