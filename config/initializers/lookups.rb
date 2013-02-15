LOOKUP_TABLES = Dir.glob(Rails.root.join("app","models","*_lookup.rb")).collect{|m| ::File.basename(m,".rb").camelcase}
