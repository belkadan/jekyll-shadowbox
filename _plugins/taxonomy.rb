# Based on the tag and category plugins by Jose Diaz-Gonzalez
# https://github.com/josegonzalez/josediazgonzalez.com/tree/master/_plugins

module Taxonomy

  class Index < Jekyll::Page
    def initialize(site, dir, groupname, group, layout, name = 'index.html')
      @site = site
      @base = site.source
      @dir = File.join(dir, groupname.to_xml_id)
      @name = name
      
      self.process(@name)
      self.data = {
        'layout' => layout,
        'posts' => group.reverse,
        'name' => groupname,
        'title' => 'Archive for “' + groupname.taxonomy_name + '”',
        'related' => group.map{|p| p.tags }.reduce(:+).uniq.sort
      }
    end
  end

  class Atom < Index
    def initialize(site, dir, groupname, group)
      super(site, dir, groupname, group, 'atom', 'atom.xml')
    end
  end

  class List < Jekyll::Page
    def initialize(site, dir, taxonomy, layout)
      @site = site
      @base = site.source
      @dir = dir
      @name = 'index.html'

      self.process(@groupname)
      self.read_yaml(File.join(@base, '_layouts'), layout)
      self.data['taxonomy'] = taxonomy
      self.data['layout'] = layout
    end
  end

  class Generator < Jekyll::Generator
    safe true
    
    def generate(site)
      if site.layouts.key? 'tag_index'
        dir = site.config['tag_dir'] || '/tags'
        site.tags.each do |tag, posts|
          site.pages << Index.new(site, dir, tag, posts, 'tag_index') << Atom.new(site, dir, tag, posts)
        end
      end

      if site.layouts.key? 'tag_list'
        dir = site.config['tag_dir'] || '/tags'
        site.pages << List.new(site, dir, site.tags.keys.sort, 'tag_list')
      end

      if site.layouts.key? 'category_index'
        dir = site.config['category_dir'] || '/categories'
        site.categories.each do |category, posts|
          site.pages << Index.new(site, dir, category, posts, 'category_index') << Atom.new(site, dir, category, posts)
        end
      end

      if site.layouts.key? 'category_list'
        dir = site.config['category_dir'] || '/categories'
        site.pages << List.new(site, dir, site.categories.keys.sort, 'category_list')
      end
    end
  end

end
