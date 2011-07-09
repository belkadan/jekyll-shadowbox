# Based on a plugin by Jose Diaz-Gonzalez
# https://github.com/josegonzalez/josediazgonzalez.com/tree/master/_plugins

module Jekyll
  class Site
    # Constuct an array of hashes that will allow the user, using Liquid, to
    # iterate through the keys of _kv_hash_ and be able to iterate through the
    # elements under each key.
    #
    # Example:
    #   categories = { 'Ruby' => [<Post>, <Post>] }
    #   make_iterable(categories, :index => 'name', :items => 'posts')
    # Will allow the user to iterate through all categories and then iterate
    # though each post in the current category like so:
    #   {% for category in site.categories %}
    #     h1. {{ category.name }}
    #     <ul>
    #       {% for post in category.posts %}
    #         <li>{{ post.title }}</li>
    #       {% endfor %}
    #       </ul>
    #   {% endfor %}
    # 
    # Returns [ {<index> => <kv_hash_key>, <items> => kv_hash[<kv_hash_key>]}, ... ]
    def make_iterable(kv_hash, options)
      options = {:index => 'name', :items => 'items'}.merge(options)
      result = []
      kv_hash.sort.each do |key, value|
        result << { options[:index] => key, options[:items] => value }
      end
      result
    end

    alias_method :shadowbox_iterator_site_payload, :site_payload
    def site_payload
      @shadowbox_iterator_cache ||= {
        'categories'  => make_iterable(self.categories, :index => 'name', :items => 'posts'),
        'tags'        => make_iterable(self.tags, :index => 'name', :items => 'posts')
      }
      
      payload = shadowbox_iterator_site_payload
      payload['site']['iterable'] = @shadowbox_iterator_cache
      payload
    end

    alias_method :shadowbox_iterator_reset, :reset
    def reset
      shadowbox_iterator_reset
      @shadowbox_iterator_cache = nil
    end
  end
end