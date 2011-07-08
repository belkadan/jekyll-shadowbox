module Jekyll
  begin
    # If we have ptools, we can skip processing of binary files
    require 'ptools'
    
    module Convertible
      alias_method :shadowbox_dirposts_read_yaml, :read_yaml
      def read_yaml(base, name)
        filename = File.join(base, name)
        if File.binary?(filename)
          self.content = File.read(filename)
          self.data = {}
          @shadowbox_binary = true
        else
          shadowbox_dirposts_read_yaml(base, name)
        end
      end
    end
  rescue LoadError
    # No ptools; oh well...we may get some funny Liquid errors.
  end
  
  class Post
    alias_method :name, :slug unless method_defined?(:name)

    def html?
      output_ext == '.html'
    end unless method_defined?(:html?)
    
    def shadowbox_compound_post?
      File.dirname(self.slug) != '.'
    end

    alias_method :shadowbox_dirposts_destination, :destination
    def destination(dest)
      if shadowbox_compound_post?
        base_url = File.dirname(CGI.unescape(self.url))
        base_post = self.site.shadowbox_dirposts_rewritten_dirs[base_url]
        if base_post then
          dirname = base_post.url
        else
          dirname = CGI.unescape(File.dirname(self.slug))
        end

        basename = CGI.unescape(File.basename(self.slug))

        path = File.join(dest, dirname, basename)
        path << output_ext
        path
      else
        shadowbox_dirposts_destination(dest)
      end
    end

    alias_method :shadowbox_dirposts_process, :process
    def process(name)
      shadowbox_dirposts_process(name)
      if File.basename(self.slug) == 'index'
        self.slug = File.dirname(self.slug)
        self.site.shadowbox_dirposts_rewritten_dirs[self.url] = self
      end
    end
  end
  
  class Site
    def shadowbox_dirposts_rewritten_dirs
      @shadowbox_dirposts_rewritten_dirs = {} if not @shadowbox_dirposts_rewritten_dirs
      @shadowbox_dirposts_rewritten_dirs
    end
    
    alias_method :shadowbox_dirposts_read_posts, :read_posts
    def read_posts(dir)
      shadowbox_dirposts_read_posts(dir)
      compound_posts, self.posts = self.posts.partition(&:shadowbox_compound_post?)
      
      compound_posts.each do |p|
        if p.data.empty?
          p.output = p.content
          static_files << p
        else
          pages << p
        end
      end
      
      self.categories.each_value do |cat|
        cat.reject!(&:shadowbox_compound_post?)
      end
    end
  end
end
