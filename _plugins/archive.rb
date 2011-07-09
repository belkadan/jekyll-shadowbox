# Based on a plugin by Jose Diaz-Gonzalez
# https://github.com/josegonzalez/josediazgonzalez.com/tree/master/_plugins

module Jekyll

  class ArchiveIndex < Page    
    def initialize(site, base, dir, type, collated_posts)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), type + '.html')

      _, year, month, day = dir.split('/')
      self.data['year'] = year.to_i
      month and self.data['month'] = month.to_i
      day and self.data['day'] = day.to_i
      
      self.data['title'] = 'Archive for '
      if month
        self.data['title'] << Date::MONTHNAMES[month.to_i] << ' '
        if day
          self.data['title'] << day.to_i << ', '
        end
      end
      self.data['title'] << year
      
      self.data['posts'] = []
      if day
        self.data['posts'] += collated_posts[year.to_i][month.to_i][day.to_i]
      elsif month
        collated_posts[year.to_i][month.to_i].sort {|a,b| b <=> a}.each do |entry|
          self.data['posts'] += entry[1]
        end
      else
        collated_posts[year.to_i].sort {|a,b| b <=> a}.each do |month|
          month[1].sort {|a,b| b <=> a}.each do |day|
            self.data['posts'] += day[1]
          end
        end
      end
      
      self.data['posts'].each do |post| 
        self.add_dependency(post)
      end if self.respond_to?(:add_dependency)
    end    
  end

  class ArchiveGenerator < Generator
    safe true

    def generate(site)
      collated_posts = collate(site)

      collated_posts.each do |y, months|
        site.pages << ArchiveIndex.new(site, site.source, '/' + y.to_s, 'archive_yearly', collated_posts)
        months.each do |m, days|
          site.pages << ArchiveIndex.new(site, site.source, "/%04d/%02d" % [ y.to_s, m.to_s ], 'archive_monthly', collated_posts)
          days.each_key do |d|
            site.pages << ArchiveIndex.new(site, site.source, "/%04d/%02d/%02d" % [ y.to_s, m.to_s, d.to_s ], 'archive_daily', collated_posts)
          end if site.layouts.key? 'archive_daily'
        end if site.layouts.key? 'archive_monthly'
      end if site.layouts.key? 'archive_yearly'
    end

    def collate(site)
      collated_posts = Hash.new do |year_hash, year|
        year_hash[year] = Hash.new do |month_hash, month| 
          month_hash[month] = Hash.new do |day_hash, day| 
            day_hash[day] = []
          end
        end
      end
      site.posts.reverse.each do |post|
        y, m, d = post.date.year, post.date.month, post.date.day
        collated_posts[ y ][ m ][ d ] << post unless collated_posts[ y ][ m ][ d ].include?(post)
      end
      collated_posts
    end
  end
  
  class Site
    alias_method :shadowbox_archive_reset, :reset
    def reset
      shadowbox_archive_reset
      @shadowbox_archive_counts = nil
    end

    alias_method :shadowbox_archive_site_payload, :site_payload
    def site_payload      
      if not @shadowbox_archive_counts
        current_year = self.time.year

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

        @shadowbox_archive_counts = {
          'months' => months,
          'years' => years,
          'current-year' => current_year,
        }
      end
      
      payload = shadowbox_archive_site_payload
      payload['site'].merge!(@shadowbox_archive_counts)
      payload
    end
  end
end

