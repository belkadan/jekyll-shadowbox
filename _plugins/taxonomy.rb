# Based on the tag and category plugins by Jose Diaz-Gonzalez
# https://github.com/josegonzalez/josediazgonzalez.com/tree/master/_plugins

# FIXME: there should be a warning if two tags/categories have the same xml_id.

module Taxonomy

  class Index < Jekyll::Page
    def initialize(site, dir, groupname, group, layout, name = 'index.html')
      @site = site
      @base = site.source
      @name = name

      groupname = 'Uncategorized' if groupname == ''
      @dir = File.join(dir, groupname.to_xml_id)

      self.process(@name)
      self.data = {
        'layout' => layout,
        'posts' => group.sort {|a,b| b <=> a},
        'name' => groupname,
        'title' => 'Archive for “' + groupname.taxonomy_name + '”',
        'related' => group.map{|p| p.tags }.reduce(:+).uniq.sort,
        'dependencies' => []
      }

      group.each do |post|
        self.add_dependency(post)
      end if self.respond_to?(:add_dependency)
    end
  end

  class Atom < Index
    def initialize(site, dir, groupname, group)
      super(site, dir, groupname, group, 'atom', 'atom.xml')
      self.data['title'] = 'Latest posts in “' + groupname.taxonomy_name + '”'
    end
  end

  class List < Jekyll::Page
    def initialize(site, dir, taxonomy, layout)
      @site = site
      @base = site.source
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.data = {
        'taxonomy' => taxonomy,
        'layout' => layout,
        'dependencies' => '*'
      }
    end
  end

  class Generator < Jekyll::Generator
    safe true

    def generate(site)
      unless site.tags.empty?
        if site.layouts.key? 'tag_index'
          dir = site.config['tag_dir'] || '/tags'
          site.tags.each do |tag, posts|
            site.pages << Index.new(site, dir, tag, posts, 'tag_index')
            site.pages << Atom.new(site, dir, tag, posts) if site.config['permid']
          end
        end

        if site.layouts.key? 'tag_list'
          dir = site.config['tag_dir'] || '/tags'
          site.pages << List.new(site, dir, site.tags.keys.sort, 'tag_list')
        end
      end

      unless site.categories.empty? or site.categories.keys == ['']
        if site.layouts.key? 'category_index'
          dir = '/'
          site.categories.each do |category, posts|
            site.pages << Index.new(site, dir, category, posts, 'category_index') 
            site.pages << Atom.new(site, dir, category, posts) if site.config['permid']
          end
        end

        if site.layouts.key? 'category_list'
          dir = site.config['category_dir'] || '/categories'
          site.pages << List.new(site, dir, site.categories.keys.sort, 'category_list')
        end
      end
    end
  end

end

module Jekyll
  class Post
    alias_method :shadowbox_taxonomy_initialize, :initialize
    def initialize(site, source, dir, name)
      shadowbox_taxonomy_initialize(site, source, dir, name)
      self.categories.collect!(&:downcase)
      self.tags.collect!(&:downcase)
    end
  end
end

