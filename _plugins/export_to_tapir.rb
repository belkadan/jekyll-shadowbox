#!/usr/bin/ruby -rubygems

# This script is for new users signing up for Tapir who want to use the Tapir's
# article push feature rather than temporarily generating a full newsfeed and
# waiting for Tapir's import to complete. See tapir.yml for details.
#
# This is NOT actually a Jekyll plugin..._plugins/ just seemed like the best place to put it.

if $0 == __FILE__
  require 'net/http'
  require 'uri'
  require 'yaml'

  raise "Usage: #{File::basename($0)} <Tapir secret token> tapir.yml" if ARGV.empty?

  token = ARGV.shift
  raise "Bad token: #{token}" unless token =~ /^[a-zA-Z\d]+$/
  url_path = '/api/1/push_article?secret=' + token

  # Don't overwhelm the Tapir servers...
  DELAY = 0.2

  count = 0
  $stdout.sync = true
  YAML.each_document(ARGF) do |post|
    raise 'Input file should be generated from tapir.yml' unless post.is_a? Hash
    # Someone's going to try to feed the template in here...
    raise 'Input file should be GENERATED from tapir.yml' unless post['published_on']

    req = Net::HTTP::Post.new(url_path)
    # Tapir.yml is already CGI-escaped...possibly a stupid decision, but w/e.
    req.content_type = 'application/x-www-form-urlencoded'
    req.delete('Accept')
    req.body = %w{link title summary content published_on}.map do |x|
      "article[#{x}]=#{post[x]}"
    end.join('&')

    res = Net::HTTP.start('tapirgo.com') {|http| http.request(req) }
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      # OK
    else
      warn "While processing '#{post['title']}':"
      res.error!
    end

    count += 1
    print '.' if count % 10 == 0
    sleep DELAY
  end
  puts
  puts "#{count} posts pushed to Tapir."
end