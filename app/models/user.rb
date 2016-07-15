class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader

  #validates :name, presence: true
  #validates :email, presence: true
  #validates :avatar, presence: true, on: :update #创建用户的时候可以不传头像

  #会同时验证密码和确认密码，并加密密码
  #has_secure_password

  before_create :generate_token

  def generate_token
    begin
      self.auth_token = SecureRandom.urlsafe_base64
    end while User.exists?(auth_token: self.auth_token)
  end

  #user (id, ...)
  #picture (id, name, user_id, ...)
  has_one :picture, as: :imageable

  #保存user的时候要同时保存picture
  accepts_nested_attributes_for :picture
end
