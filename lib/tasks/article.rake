#rake article:cache RAILS_ENV=XXX
#rake article:insert RAILS_ENV=XXX
namespace :article do
  task :cache => :environment do
    #find_each每次获取一批记录，然后在代码块里逐条处理
    Article.find_each(batch_size: 2000) {|article| article.save(validate: false)}
  end

  task :insert => :environment do
    Article.destroy_all
    #Article.delete_all
    1000000.times {Article.create(title: 'green', text: 'green', author: 'Guobin', email: 'qracle@126.com', email_confirmation:'qracle@126.com', state: 1)}
    200.times {Article.create(title: 'yellow', text: 'yellow', author: 'Guobin', email: 'qracle@126.com', email_confirmation:'qracle@126.com', state: 1)}
    100.times {Article.create(title: 'red', text: 'red', author: 'Guobin', email: 'qracle@126.com', email_confirmation:'qracle@126.com', state: 1)}
    1.times {Article.create(title: 'hello world', text: 'this is a dog', author: 'Guobin', email: 'qracle@126.com', email_confirmation:'qracle@126.com', state: 1)}
    1.times {Article.create(title: 'hello china', text: 'this is a cat', author: 'Guobin', email: 'qracle@126.com', email_confirmation:'qracle@126.com', state: 1)}
  end
end
