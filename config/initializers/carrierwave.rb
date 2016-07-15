CarrierWave.configure do |config|
  config.storage = :qiniu
  config.qiniu_access_key = ''
  config.qiniu_secret_key = ''
  config.qiniu_bucket = ''
  config.qiniu_bucket_domain = ''
  config.qiniu_bucket_private = false #default is false
  config.qiniu_protocol = 'http'
  #config.qiniu_up_host = 'http://up.qiniug.com' #七牛上传海外服务器,国内使用可以不要这行配置
  config.qiniu_can_overwrite = true
end
