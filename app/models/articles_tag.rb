class ArticlesTag < ActiveRecord::Base
  belongs_to :article
  belongs_to :tag, counter_cache: :articles_count #counter_cache只能是articles_count,不能是其他，true也不行
end
