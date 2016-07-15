#source 'https://rubygems.org'
source 'https://ruby.taobao.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.13', '< 0.5'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc


#写api用
#https://github.com/ruby-grape/grape
gem 'grape'

gem 'carrierwave' #上传文件
gem 'mini_magick' #https://github.com/minimagick/minimagick
gem 'carrierwave-qiniu'

#一个分页插件
gem 'kaminari'

gem 'rest-client'#https://github.com/rest-client/rest-client

#https://github.com/mperham/sidekiq/wiki
gem 'sidekiq'

#https://github.com/mperham/sidekiq/wiki/Monitoring
# if you require 'sinatra' you get the DSL extended to Object
gem 'sinatra', :require => nil


#https://github.com/redis-store/redis-rails
gem 'redis-rails' # Will install several other redis-* gems

#https://github.com/petergoldstein/dalli
#http://memcached.org/downloads
#默认安装完成后会把memcached放到/usr/local/bin/memcached
#gem 'dalli'


#https://github.com/redis/redis-rb
gem 'redis'


#https://www.elastic.co/downloads/elasticsearch
#https://github.com/elastic/elasticsearch-rails
gem 'elasticsearch-model'
gem 'elasticsearch-rails'



# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

#https://github.com/intridea/omniauth
gem 'omniauth'

#https://github.com/intridea/omniauth-oauth2
gem 'omniauth-oauth2'


#性能监控
gem 'newrelic_rpm'

#ajax fileupload
#https://github.com/JangoSteve/remotipart
gem 'remotipart', '~> 1.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  #一个漂亮的输出错误调试页
  gem 'better_errors'

  #https://github.com/flyerhzm/bullet
  # N+1 query, unused eager loading, counter_cache
  gem "bullet"
end