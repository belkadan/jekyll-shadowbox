module Jekyll
  begin
    # If we have ptools, we can skip processing of binary files
    require 'ptools'

    module Convertible
      alias_method :shadowbox_dirposts_read_yaml, :read_yaml
      def read_yaml(base, name)
        filename = File.join(base, name)
        if File.binary?(filename)
          self.content = ''
          self.data = {}
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

    alias_method :shadowbox_dirposts_published, :published
    def published
      if shadowbox_compound_post?
        base_post = self.site.shadowbox_dirposts_rewritten_dirs[@shadowbox_dirposts_id]
        return base_post.published if base_post
      end
      shadowbox_dirposts_published
    end

    alias_method :shadowbox_dirposts_destination, :destination
    def destination(dest)
      if shadowbox_compound_post?
        base_post = self.site.shadowbox_dirposts_rewritten_dirs[@shadowbox_dirposts_id]
        if base_post then
          dirname = base_post.url
        else
          dirname = File.dirname(CGI.unescape(self.slug.gsub('+','%2B')))
        end

        basename = File.basename(CGI.unescape(self.slug.gsub('+','%2B')))

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
        self.site.shadowbox_dirposts_rewritten_dirs[File.dirname(name)] = self
      elsif shadowbox_compound_post?
        @shadowbox_dirposts_id = File.dirname(name)
      end
    end
  end

  class CompoundPostResource < StaticFile
    def destination(dest)
      base_post = @site.shadowbox_dirposts_rewritten_dirs[File.dirname(@name)]
      raise FatalException.new("Cannot have post resources without a primary post: " + @shadowbox_dirposts_id) if base_post.nil?

      File.join(dest, base_post.url, File.basename(@name))
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

      posts_path = File.join(dir, '_posts')
      compound_posts.each do |p|
        # We need to check for "published" again because compound post files
        # can be loaded before the base post (index).
        next unless p.published
        if p.data.empty?
          # Don't read the file into memory.
          static_files << CompoundPostResource.new(self, self.source, posts_path, p.name)
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
