module Jekyll
  class Post
    alias_method :shadowbox_dpt_initialize, :initialize
    def initialize(site, source, dir, name)
      shadowbox_dpt_initialize(site, source, dir, name)
      self.data['layout'] ||= site.config['default_layout'] || 'post'
    end
  end
end
