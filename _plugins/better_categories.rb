module Jekyll
  class Post
    alias_method :shadowbox_bettercategories_initialize, :initialize
    def initialize(site, source, dir, name)
      shadowbox_bettercategories_initialize(site, source, dir, name)

      # self.categories is never empty now, but the user might have
      # specified categories in YAML.
      if self.shadowbox_bettercategories_categories.empty?
        self.categories = self.data.pluralized_array('category', 'categories')
      end
    end

    alias_method :shadowbox_bettercategories_categories, :categories
    def categories
      result = shadowbox_bettercategories_categories
      if result.empty?
        ['']
      else
        result
      end
    end

    def next
      primary_category_name = self.categories[0]
      category = self.site.categories[primary_category_name]
      pos = category.index(self)
      category[pos+1] if pos # out-of-bounds is okay
    end

    def previous
      primary_category_name = self.categories[0]
      category = self.site.categories[primary_category_name]
      pos = category.index(self)
      category[pos-1] if pos and pos > 0
    end
  end
end
