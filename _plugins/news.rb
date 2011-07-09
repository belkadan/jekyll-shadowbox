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
      def handle(name, item, site)
        return false unless name == 'news'
        
        site.shadowbox_news_posts.each do |post|
          item.add_dependency(post)
        end
        
        true
      end
    end
  end
end
