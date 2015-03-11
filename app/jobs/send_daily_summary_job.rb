class SendDailySummaryJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    users = User.where(role: 'manager').or.where(role: 'admin').pluck(:email)

    users.each do |user|
      ImportMailer.daily_summary(user).deliver_now
    end
  end
end
