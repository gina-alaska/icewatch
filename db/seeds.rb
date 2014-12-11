# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Dir.glob("db/lookups/*.json").each do |lookup_file|
  table = File.basename(lookup_file, "s.json").camelize.constantize
  JSON.parse(File.read(lookup_file)).each do |lookup|
    puts "Creating #{table} - #{lookup['code'].to_s}: #{lookup.inspect}"
    r = table.where(code: lookup['code'].to_s).first_or_create(lookup)
  end
end
