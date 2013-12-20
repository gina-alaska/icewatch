namespace :user do
  desc "Copy uid/provider from user to authorizations"
  task update: :environment do
    User.all.each do |u|
      Authorization.create(provider: u.provider, uid: u.uid, user: u)
    end
  end
end