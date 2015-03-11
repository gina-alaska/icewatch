class ImportMailer < ApplicationMailer
  default from: 'admin@icewatch.gina.alaska.edu'

  def daily_summary(email)
    cruise_ids = Observation.saved.pluck(:cruise_id).uniq
    return if cruise_ids.empty?

    @cruises = Cruise.where(id: cruise_ids)

    mail(to: email, subject: 'IceWatch Daily Summary')
  end
end
