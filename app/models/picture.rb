class Picture < ActiveRecord::Base
  mount_uploader :name, AvatarUploader
  belongs_to :imageable, polymorphic: true
end