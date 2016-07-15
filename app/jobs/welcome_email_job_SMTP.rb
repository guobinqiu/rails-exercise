class WelcomeEmailJobSMTP < ApplicationJob
  queue_as :mailers

  def perform(user_id)
    UserMailer.welcome_email_smtp(user_id).deliver_now
  end
end
