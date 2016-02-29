class ImportMailer < ApplicationMailer
  default from: 'admin@icewatch.gina.alaska.edu'

  def daily_summary(email, cruises, users)
    @users = users
    @cruises = cruises

    mail(to: email, subject: 'IceWatch Daily Summary')
  end
end
