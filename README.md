Ruby on Rails
---

# 创建controller
rails generate controller Articles

# 创建model
rails generate model Article title:string text:text (会自动生成迁移文件)

rails generate model Comment commenter:string body:text article:references

# 用户注册登录
rails g model user name:string email:string password_digest:string

rails g controller users signup

rails g migration AddAuthTokenToUsers auth_token:string

# 分页
https://github.com/amatsuda/kaminari

rails g kaminari:config

# 文件上传
https://github.com/carrierwaveuploader/carrierwave

rails generate uploader Avatar

# 多态
rails g migration CreatePictures name:string imageable_id:integer imageable_type:string

# 邮件
rails g mailer UserMailer

