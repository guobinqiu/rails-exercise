require 'omniauth/strategies/qq.rb'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :qq, '101290951', 'fdb9b29d160948c8b7fb01a9a657f47e'
end