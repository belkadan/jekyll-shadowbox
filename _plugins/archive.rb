# Based on a plugin by Jose Diaz-Gonzalez
# https://github.com/josegonzalez/josediazgonzalez.com/tree/master/_plugins

module Jekyll

  class ArchiveIndex < Page    
    def initialize(site, base, dir, type)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), type + '.html')
      self.data['collated_posts'] = self.collate(site)

      year, month, day = dir.split('/')
      self.data['year'] = year.to_i
      month and self.data['month'] = month.to_i
      day and self.data['day'] = day.to_i
      
      self.data['title'] = 'Archive for ';
      if month
        self.data['title'] << Date::MONTHNAMES[month.to_i] << ' '
        if day
          self.data['title'] << day.to_i << ', '
        end
      end
      self.data['title'] << year
      
      self.data['posts'] = []
      if day
        self.data['posts'] += self.data['collated_posts'][year.to_i][month.to_i][day.to_i]
      elsif month
        self.data['collated_posts'][year.to_i][month.to_i].sort {|a,b| b <=> a}.each do |entry|
          self.data['posts'] += entry[1]
        end
      else
        self.data['collated_posts'][year.to_i].sort {|a,b| b <=> a}.each do |month|
          month[1].sort {|a,b| b <=> a}.each do |day|
            self.data['posts'] += day[1]
          end
        end
      end
    end

    def collate(site)
      collated_posts = {}
      site.posts.reverse.each do |post|
        y, m, d = post.date.year, post.date.month, post.date.day
        
        collated_posts[ y ] = {} unless collated_posts.key? y
        collated_posts[ y ][ m ] = {} unless collated_posts[y].key? m
        collated_posts[ y ][ m ][ d ] = [] unless collated_posts[ y ][ m ].key? d
        collated_posts[ y ][ m ][ d ].push(post) unless collated_posts[ y ][ m ][ d ].include?(post)
      end
      return collated_posts
    end
    
  end

  class ArchiveGenerator < Generator
    safe true
    attr_accessor :collated_posts


    def generate(site)
      self.collated_posts = {}
      collate(site)

      self.collated_posts.keys.each do |y|
        site.pages << ArchiveIndex.new(site, site.source, y.to_s, 'archive_yearly')
        # write_archive_index(site, y.to_s, 'archive_yearly')
        self.collated_posts[ y ].keys.each do |m|
          site.pages << ArchiveIndex.new(site, site.source, "%04d/%02d" % [ y.to_s, m.to_s ], 'archive_monthly')
          # write_archive_index(site, "%04d/%02d" % [ y.to_s, m.to_s ], 'archive_monthly')
          self.collated_posts[ y ][ m ].keys.each do |d|
            site.pages << ArchiveIndex.new(site, site.source, "%04d/%02d/%02d" % [ y.to_s, m.to_s, d.to_s ], 'archive_daily')
            # write_archive_index(site, "%04d/%02d/%02d" % [ y.to_s, m.to_s, d.to_s ], 'archive_daily')
          end if site.layouts.key? 'archive_daily'
        end if site.layouts.key? 'archive_monthly'
      end if site.layouts.key? 'archive_yearly'
    end

    def write_archive_index(site, dir, type)
      archive = ArchiveIndex.new(site, site.source, dir, type)
      archive.render(site.layouts, site.site_payload)
      archive.write(site.dest)
      site.static_files << archive
    end

    def collate(site)
      site.posts.reverse.each do |post|
        y, m, d = post.date.year, post.date.month, post.date.day
        
        self.collated_posts[ y ] = {} unless self.collated_posts.key? y
        self.collated_posts[ y ][ m ] = {} unless self.collated_posts[y].key? m
        self.collated_posts[ y ][ m ][ d ] = [] unless self.collated_posts[ y ][ m ].key? d
        self.collated_posts[ y ][ m ][ d ].push(post) unless self.collated_posts[ y ][ m ][ d ].include?(post)
      end
    end
  end
  
  class Site
    alias_method :old_site_payload, :site_payload
    
    def site_payload
      current_year = Time.new.year
      
      months = []
      years = []
      self.posts.reverse.each do |post|
        y, m, d = post.date.year, post.date.month, post.date.day
        
        if y == current_year
          if months.empty? or months.last['num'] != m
            months.push({ 'num' => m, 'count' => 1})
          else
            months.last['count'] += 1
          end
        else
          if years.empty? or years.last['num'] != y
            years.push({ 'num' => y, 'count' => 1})
          else
            years.last['count'] += 1
          end
        end
      end

      added = {
        'months' => months,
        'years' => years,
        'current-year' => current_year,
      }
      
      payload = old_site_payload
      payload['site'].merge! added
      payload
    end
  end
end

