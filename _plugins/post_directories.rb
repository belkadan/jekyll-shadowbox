module Jekyll
  begin
    # If we have ptools, we can skip processing of binary files
    require 'ptools'
    
    module Convertible
      def shadowbox_binary?
        @shadowbox_binary
      end
      
      alias_method :shadowbox_read_yaml, :read_yaml
      def read_yaml(base, name)
        if File.binary?(File.join(base, name))
          self.content = File.read(File.join(base, name))
          self.output = self.content
          self.data = {}
          @shadowbox_binary = true
        else
          shadowbox_read_yaml(base, name)
        end
      end
    end
  rescue LoadError
    # No ptools; oh well
    module Convertible
      def shadowbox_binary?
        false
      end
    end
  end
  
  class Post
    alias_method :name, :slug

    def html?
      output_ext == '.html'
    end unless method_defined?(:html?)
    
    def shadowbox_compound_post?
      File.dirname(self.slug) != '.'
    end

    alias_method :shadowbox_destination, :destination
    def destination(dest)
      if shadowbox_compound_post?
        path = File.join(dest, CGI.unescape(self.url))
        path += output_ext
        path
      else
        shadowbox_destination(dest)
      end
    end

    alias_method :shadowbox_process, :process
    def process(name)
      shadowbox_process(name)
      if File.basename(self.slug) == 'index'
        self.slug = File.dirname(self.slug)
      end
    end
  end
  
  class Site
    alias_method :shadowbox_read_posts, :read_posts
    def read_posts(dir)
      shadowbox_read_posts(dir)
      compound_posts, self.posts = self.posts.partition do |p|
        p.shadowbox_compound_post?
      end
      
      compound_posts.each do |p|
        if p.shadowbox_binary?
          static_files
        else
          pages
        end << p
      end
    end
  end
end
