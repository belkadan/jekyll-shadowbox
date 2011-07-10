module Jekyll
  module Convertible
    def shadowbox_shtml_uses_ssi?
      return true if self.data['uses_ssi']
      
      layout = self.site.layouts[self.data['layout']]
      layout.shadowbox_shtml_uses_ssi? if layout
    end
  end
  
  class Post
    alias_method :shadowbox_shtml_write, :write
    def write(dest)
      shadowbox_shtml_write(dest)
      File.chmod(0755, destination(dest)) if shadowbox_shtml_uses_ssi?
    end
  end

  class Page
    alias_method :shadowbox_shtml_write, :write
    def write(dest)
      shadowbox_shtml_write(dest)
      File.chmod(0755, destination(dest)) if shadowbox_shtml_uses_ssi?
    end
  end
end