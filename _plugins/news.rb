module Jekyll
  class Site
    alias_method :shadowbox_news_site_payload, :site_payload
    def site_payload
      @shadowbox_news_posts = self.posts.reject do |p|
        p.data['no_news']
      end.reverse unless @shadowbox_news_posts
      
      payload = shadowbox_news_site_payload
      payload['site']['news_posts'] = @shadowbox_news_posts
      payload
    end
  end
end
