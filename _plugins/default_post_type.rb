module Jekyll
  class Post
    if self.instance_methods(false).include?(:read_yaml)
      alias_method :shadowbox_dpt_read_yaml, :read_yaml
      def read_yaml(base, name)
        shadowbox_dpt_read_yaml(base, name)
        self.data['layout'] ||= site.config['default_layout'] || 'post' unless self.data.empty?
      end
    else
      def read_yaml(base, name)
        super
        self.data['layout'] ||= site.config['default_layout'] || 'post' unless self.data.empty?
      end
    end
  end
end
