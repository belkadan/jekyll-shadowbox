module Jekyll
  class Site
    alias_method :shadowbox_news_reset, :reset
    def reset
      shadowbox_news_reset
      @shadowbox_news_posts = nil
    end

    alias_method :shadowbox_news_site_payload, :site_payload
    def site_payload
      payload = shadowbox_news_site_payload
      payload['site']['news_posts'] = shadowbox_news_posts
      payload
    end

    def shadowbox_news_posts
      @shadowbox_news_posts ||= self.posts.reject do |p|
        p.data['no_news']
      end.reverse
    end
  end

  if defined? DependencyHandler
    class NewsDependencyHandler < DependencyHandler
      def handle(name, site)
        Dependency.new(*site.shadowbox_news_posts) if name == 'news'
      end
    end
  end
end
