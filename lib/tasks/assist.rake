namespace :cruise do  
  namespace :assist do
    desc "Generate assist for cruises"
    task generate: :environment  do
      Cruise.where(assist: nil).each do |cruise|
        puts "Queueing #{cruise.ship}"
        AssistWorker.perform_async(cruise.id)
      end
    end
    
    desc "Regenerate ASSIST for all cruises using the lastest version"
    task regenerate: :environment do
      Cruise.all.each do |cruise|
        puts "Queueing #{cruise.ship}"
        AssistWorker.perform_async(cruise.id)
      end
    end
  end
end