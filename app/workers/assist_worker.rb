class AssistWorker
  class CloneError < StandardError; end
  
  include Sidekiq::Worker

  def perform(cruise_id, count=nil)
    #Get the cruise information from the database
    cruise = Cruise.where(id: cruise_id).first
    ENV["RAILS_ENV"] = "production"

    dir = Dir.mktmpdir
      Dir.chdir(dir) do 
        #status = system('git clone http://github.com/gina-alaska/ASSIST.git .')
        status = system('git clone /Users/scott/workspace/iceobs .')
        raise CloneError if status == false
        system("script/package.sh #{cruise_id} #{cruise.ship}")
        #Attach the generated zip file to the cruise
        file = Dir.glob("ASSIST*.zip").first
        cruise.assist.store!(File.open(file))
        cruise.save!
      end

    puts dir
    puts Dir.glob(File.join(dir, "*.zip"))
  
  end
end