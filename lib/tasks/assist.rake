namespace :assist do
  task :package do
    # Test that we're in JRUBY
    abort "Please use JRUBY" unless RUBY_PLATFORM == 'java'

    ENV['RAILS_ENV'] = "production"
    ENV['ICEWATCH_ASSIST'] = "true"
    ENV['SECRET_KEY_BASE'] = '31f071a9f7a37810dbfaa253b07c972be761a1fe90db090fb97382c12f84d8f0d0216ca9feddb430dc95c0e48f79b6a0136c6664e5a07d067dc7305b9b1e4fd3'

    FileUtils.rm("ASSIST_2016.zip") if File.exist?("ASSIST_2016.zip")
    FileUtils.rm("db/production.sqlite3") if File.exist?("db/production.sqlite3")
    FileUtils.safe_unlink("public/assets") if File.exist?("public/assets")

    Rake::Task['db:setup'].invoke
    Rake::Task['assets:precompile'].invoke

    sh 'warble executable war'
    sh 'zip -j ASSIST_2016.zip ASSIST.war exports/launcher* db/production.sqlite3'
  end
end
