class Comment < ActiveRecord::Base
  #or counter_cache: true
  #or touch: true
  belongs_to :article, counter_cache: :comments_count, touch: :updated_at #->{ where ...}
  default_scope { order(updated_at: :desc) }
  validates_presence_of :commenter, :body
end
