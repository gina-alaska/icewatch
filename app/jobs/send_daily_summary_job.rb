class SendDailySummaryJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    users = User.where(role: ['manager','admin']).pluck(:email)

    cruise_ids = Observation.saved.pluck(:cruise_id).uniq
    new_users = User.where('created_at > ?', 24.hours.ago.beginning_of_day)

    if cruise_ids.any? || new_users.any?
      cruises = Cruise.where(id: cruise_ids)
      users.each do |user|
        ImportMailer.daily_summary(user, cruises, new_users).deliver_now
      end
    end
  end
end
