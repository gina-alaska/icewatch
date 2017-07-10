namespace :admin do
  desc "Set user as admin"
  task :user => :environment do
    email = ENV['EMAIL']
    if email.blank?
      user = User.last
    else
      user = User.where(email: email).first
    end

    user.role = 'admin'
    user.save
  end
end
