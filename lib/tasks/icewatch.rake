desc "Bootstrap the rails environment"
task bootstrap: :environment do
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
end