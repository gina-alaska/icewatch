# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  def new_user
    AdminMailer.new_user(User.first)
  end
  
  def new_cruise
    AdminMailer.new_cruise(Cruise.first, User.first)
  end
  
  def new_csv_upload
    AdminMailer.new_csv_upload(Observation)
  end
end
