$: << File.dirname(__FILE__)
require 'truncate'
require 'uri'

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

  def no_domain(input)
    URI::parse(input).path
  end
end

class String
  @@shadowbox_taxonomy_special_cases = nil

  def to_xml_id
    downcase.gsub('c++', 'cxx').gsub(/[\/\s]/, '-').gsub(/[^-\w]/, '')
  end
  
  def taxonomy_name
    if @@shadowbox_taxonomy_special_cases.nil?
      special_cases = {}
      begin
        File.open(File.join(File.dirname(__FILE__), 'special-cases.txt')) do |f|
          f.each_line do |line|
            next if line.start_with?('#')

            fields = line.chomp.split("\t")
            case fields.length
            when 0
              # do nothing
            when 1
              puts "Duplicate case entry for #{fields[0]}" if special_cases[fields[0]]
              special_cases[fields[0]] = fields[0]
            when 2
              puts "Duplicate case entry for #{fields[0]}" if special_cases[fields[0]]
              special_cases[fields[0]] = fields[1]
            else
              puts "Invalid case entry: '#{line}'"
            end
          end
        end
      rescue Errno::ENOENT
        # if the file doesn't exist, ignore it
      end
      @@shadowbox_taxonomy_special_cases = special_cases
    end

    result = capitalize
    @@shadowbox_taxonomy_special_cases.each do |k, v|
      result.gsub!(/\b#{k}\b/i, v)
    end
    
    # Special case for Objective-*
    result.gsub!(/\bobjective-([a-z]+)\b/i) {|_| "Objective-#{$1.taxonomy_name}" }
    result
  end
end


Liquid::Template.register_filter(ExtendedFilters)
