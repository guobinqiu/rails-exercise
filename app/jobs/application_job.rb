class ApplicationJob < ActiveJob::Base
  queue_as :default

  around_perform do |job, block|
    puts "-" * 88 + " start " + self.class.name
    block.call
    puts "-" * 88 + " end " + self.class.name
  end
end