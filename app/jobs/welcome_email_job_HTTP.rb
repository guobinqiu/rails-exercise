class WelcomeEmailJobHTTP < ApplicationJob
  queue_as :mailers

  def perform(user_id)
    UserMailer.welcome_email_http(user_id).deliver_now
  end
end
