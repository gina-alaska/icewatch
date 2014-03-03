# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Dir.glob("db/*_lookups.yml").each do |seed|
  puts seed
  table = File.basename(seed).chomp("s.yml").camelcase.constantize
  seed_data = YAML.load_file(seed)
  seed_data.each do |data|
    item = table.where(code: data[:code]).first_or_create 
    item.update_attributes(data)
  end
end