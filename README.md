### 创建controller

rails generate controller Articles

### 创建model

rails generate model Article title:string text:text (会自动生成迁移文件)

rails generate model Comment commenter:string body:text article:references

### 注册 & 登录

rails g model user name:string email:string password_digest:string

rails g controller users signup

rails g migration AddAuthTokenToUsers auth_token:string

### 分页

rails g kaminari:config

> https://github.com/amatsuda/kaminari

### 上传

rails generate uploader Avatar

> https://github.com/carrierwaveuploader/carrierwave

### 多态
rails g migration CreatePictures name:string imageable_id:integer imageable_type:string

### 邮件
rails g mailer UserMailer
