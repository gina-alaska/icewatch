# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
%w{
biota_lookup
cloud_lookup
floe_size_lookup
ice_lookup
max_depth_lookup
pattern_lookup
surface_lookup
open_water_lookup
sediment_lookup
snow_lookup
topography_lookup
visibility_lookup
weather_lookup
}.each do |file|
  puts file
  eval(file.camelcase).delete_all
  YAML.load_file("db/#{file}s.yml").each do |record|
    eval(file.camelcase).create( record )
  end
end