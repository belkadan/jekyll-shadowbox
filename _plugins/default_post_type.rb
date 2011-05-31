module Jekyll
  class Post
    alias_method :shadowbox_initialize, :initialize
    def initialize(site, source, dir, name)
      shadowbox_initialize(site, source, dir, name)
      self.data['layout'] ||= site.config['default_layout'] || 'post'
    end
  end
end
