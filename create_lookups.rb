#!/usr/bin/env/ruby

require 'httparty'
require 'fileutils'
require 'active_support/core_ext/string/inflections'

response = HTTParty.get('http://icewatch.gina.alaska.edu/api/lookups.json')
lookups = JSON.parse(response.body)

FileUtils.mkdir_p('db/lookups')

lookups.each do |name, values|
  File.open("db/lookups/#{name.tableize}.json", 'w') do |f|
    f << JSON.pretty_generate(values)
  end
end
