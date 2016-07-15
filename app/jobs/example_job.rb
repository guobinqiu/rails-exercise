class ExampleJob < ApplicationJob
  def perform(user_id)
    sleep(10)
    puts '-' * 88 + User.find(user_id).name
  end
end
