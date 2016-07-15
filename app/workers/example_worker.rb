#https://github.com/mperham/sidekiq/wiki/Getting-Started
class ExampleWorker
  include Sidekiq::Worker

  def perform(user_id)
    sleep(10)
    puts '-' * 88 + User.find(user_id).name
  end

end
