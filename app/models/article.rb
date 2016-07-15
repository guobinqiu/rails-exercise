class Article < ActiveRecord::Base
  include ArticleSearchable
  include Cacheable


  #self.table_name = "articles"
  #self.primary_key = "id"

  #单个设
  validates :title, presence: true
  validates :text, presence: true
  #批量设
  #validates_presence_of :title, :text

  validates :email, confirmation: true
  validates :email_confirmation, presence: true

  #自定义验证
  #validate :custom_valid

  #def custom_valid
  #  errors.add(:expiration_date, "can't be in the past")
  #  errors[:base] << "Expiration date can't be in the past" #错误消息可以添加到整个对象上，而不是针对某个属性。
  #end

  #不会存入数据库
  validates :terms_of_service, acceptance: true

  #对象生命周期内回调
  #log = ""
  #
  #after_initialize do
  #  puts "article --after initialize #{log}"
  #end
  #
  #before_validation do
  #  puts "article --before validation #{log}"
  #end
  #
  #after_validation do
  #  puts "article --before validation #{log}"
  #end
  #
  #before_save do
  #  puts "article --before save #{log}"
  #end
  #
  #before_create do
  #  puts "article --before create #{log}"
  #end
  #
  #after_create do
  #  puts "article --after create #{log}"
  #end
  #
  #before_update do
  #  puts "article --before update #{log}"
  #end
  #
  #after_update do
  #  puts "article --after update #{log}"
  #end
  #
  #after_save do
  #  puts "article --after save #{log}"
  #end
  #
  #before_destroy do
  #  puts "article --before destroy #{log}"
  #end
  #
  #after_destroy do
  #  puts "article --after destroy #{log}"
  #end
  #after_commit do
  #  puts "article --after commit #{log}"
  #end

  #删除文章时关联删除评论
  has_many :comments, dependent: :destroy


  #Article对象获得的隐式方法
  #@article.tags(force_reload = false)
  #@article.tags<<(object, ...)
  #@article.tags.delete(object, ...)
  #@article.tags.destroy(object, ...)
  #@article.tags=objects
  #@article.tag_ids
  #@article.tag_ids=ids
  #@article.tags.clear
  #@article.tags.empty?
  #@article.tags.size
  #@article.tags.find(...)
  #@article.tags.where(...)
  #@article.tags.exists?(...)
  #@article.tags.build(attributes = {}, ...)
  #@article.tags.create(attributes = {})
  #@article.tags.create!(attributes = {})
  has_many :articles_tags
  has_many :tags, through: :articles_tags


  #指定默认作用域
  default_scope { order(updated_at: :desc) }

  #可以在类上或者作为关联对象被调用
  scope :active, -> { where(state: 1) }
  scope :inactive, -> { where(state: 0) }

  #把article和它的comments一起保存
  accepts_nested_attributes_for :comments

  #写法一
  #after_commit Proc.new {|article| cache_write article}, on: [:create, :update]
  #after_commit Proc.new {|article| cache_delete article}, on: :destroy

  #写法二
  #after_commit lambda { |article| cache_write article}, on: [:create, :update]
  #after_commit lambda { |article| cache_delete article}, on: :destroy

  #写法三
  #after_commit -> { cache_write self}, on: [:create, :update]
  #after_commit -> { cache_delete self}, on: :destroy

  #写法四
  #after_commit :f1, on: [:create, :update]
  #after_commit :f2, on: :destroy
  #
  #def f1
  #  cache_write self
  #end
  #
  #def f2
  #  cache_delete self
  #end

  #写法五
  #自动实时索引
  after_commit on: [:create] do
    cache_write self
    __elasticsearch__.index_document
  end

  after_commit on: [:update] do
    cache_write self
    __elasticsearch__.update_document
  end

  after_commit on: [:destroy] do
    cache_delete self
    __elasticsearch__.delete_document
  end

  def self.db_search(query)
    if query.blank?
      all
    else
      where('title like :search or text like :search', search: "%#{query}%")
    end
  end

  def self.db_search_only(query, page, per_page)
    db_search(query).page(page).per(per_page)
  end

  def self.db_search_mixin_cache(query, page, per_page)
    articles = db_search(query).page(page).per(per_page)
    if articles.size > 0
      article_ids = articles.map{|a|"article_#{a.id}"}
      array_articles = cache_read_multi(article_ids)
    else
      array_articles = []
    end
    Kaminari.paginate_array(array_articles, {limit: articles.limit_value, offset: articles.offset_value, total_count: articles.total_count})
  end

  def self.es_search_only(query, page, per_page)
    search(query).page(page).per(per_page).records
  end

  def self.es_search_mixin_cache(query, page, per_page)
    response = search(query).page(page).per(per_page)
    if response.results.total > 0
      article_ids = response.results.map{|result|"article_#{result._source.id}"}
      #article_ids = response.results.map{|result| [Article.class.to_s.underscore, result._source.id].join('-')}
      array_articles = cache_read_multi(article_ids)
    else
      array_articles = []
    end
    Kaminari.paginate_array(array_articles, {limit: response.limit_value, offset: response.offset_value, total_count: response.total_count})
  end

end
#实例方法不能调类方法
#类方法不能调实例方法
