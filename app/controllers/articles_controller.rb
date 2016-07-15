class ArticlesController < ApplicationController

  #before_action do
  #  @tags = Tag.all
  #end

  before_action :load_tags, only: [:new, :edit, :update, :create]

  before_action :load_article, only: [:show, :show_more, :edit, :update, :destroy]

  #around_action :take_how_long, only: :search


  def new
    #@tags = Tag.all
    @article = Article.new

    @article.comments.build
    #3.times { @article.comments.build }
  end

  def create
    #{"utf8"=>"✓", "authenticity_token"=>"dPKH+6wpwb60HHbpiF8eED765ZManGKqo5yGxtwOq+WDHPHEwYnVELuPE4TSyP2ND29RfPpwEtcQt3irVzftuw==", "my_article"=>{"title"=>"a", "text"=>"b"}, "commit"=>"提交", "controller"=>"articles", "action"=>"create"}
    #render plain: params.inspect

    #{"title"=>"a", "text"=>"b"}
    #render plain: params[:my_article].inspect

    #a
    #render plain: params[:my_article][:title]

    #@article = Article.new
    #@article.title = params[:my_article][:title]
    #@article.text = params[:my_article][:text]
    #@article.save

    @article = Article.new(article_params)
    if @article.save
      #redirect_to action: 'show', id: @article.id
      #redirect_to action: 'show', id: @article
      #redirect_to article_path(@article.id)
      redirect_to article_path(@article)
      #redirect_to @article
    else
      #byebug
      #render 'new'
      render new_article_path
    end

  end

  def show
    #@article = Article.find(params[:id])
    #@comments = @article.comments.order(created_at: :desc).page(params[:page])
    @comments = @article.comments.page(params[:page])
  end

  def show_more
    #render js: "alert('hello')"

    #@article = Article.find(params[:id])
    #@comments = @article.comments.order(created_at: :desc).page(params[:page])
    @comments = @article.comments.page(params[:page])
  end

  #https://github.com/amatsuda/kaminari/issues/293
  #https://github.com/amatsuda/kaminari
  # Paginating a generic Array object
  def index
    #@articles = Article.all.page(params[:pg]).per(3)
    #@articles = Article.all.page(params[:page]).includes(:comments)  #用includes避免n+1查询

    #查看sql执行计划: Article.all.page(params[:page]).explain
    @articles = Article.all.page(params[:page])
  end

  def edit
    #@tags = Tag.all
    #@article = Article.find(params[:id])
    unless current_user
      session[:return_to] = request.url
      redirect_to login_users_path
    end
  end

  def update
    #@tags = Tag.all
    #{"utf8"=>"✓", "_method"=>"patch", "authenticity_token"=>"lFMCKRUMGK//mlqDrYi7gYrcIqFz6wPWdNNvBfpwJs9zJV7HL4EwDgDrvp8oeKbFnR4JnSrsczGPIeWfHx1klA==",
    # "article"=>{"title"=>"a", "text"=>"b", "email"=>"qracle@126.com", "email_confirmation"=>"",
    # "terms_of_service"=>"0", "tag_ids"=>["1", "2", "3", "4"]}, "commit"=>"提交", "controller"=>"articles", "action"=>"update", "id"=>"9"}
    #render plain: params

    #@article = Article.find(params[:id])


    #单独赋值时不会使用strong parameter验证
    #@article.title = params[:article][:title]
    #@article.text = params[:article][:text]
    #@article.email = params[:article][:email]
    #@article.tag_ids = params[:article][:tag_ids]
    #@article.email_confirmation = params[:article][:email_confirmation]
    #if @article.save

    #if @article.update_attributes(article_params)
    if @article.update(article_params)
      #redirect_to @article
      redirect_to article_path(@article)
    else
      render 'edit'
      #render edit_article_path(@article)
    end
  end

  def destroy
    #@article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_path
  end

  def test_json
    render json: Article.all.limit(3).to_json
  end

  def test_js
  end

  def search
    #@articles = Article.all.page(params[:page])
    #if params[:search].present?

      #条件查询
      #以下所有写法等效

      #1.纯字符串方式，有SQL注入问题，永远不要这么写
      #@articles = @articles.where("title = '#{params[:search]}' and text = '#{params[:search]}'")

      #2.数组方式
      #@articles = @articles.where('title = ? and text = ?', params[:search], params[:search])

      #3.占位符方式
      #@articles = @articles.where('title = :search and text = :search', search: params[:search])

      #4.Hash方式完整写
      #@articles = @articles.where(articles: { title: params[:search], text: params[:search] })

      #5.Hash方式简写
      #@articles = @articles.where(title: params[:search], text: params[:search])

      #6.把and条件分开写
      #@articles = @articles.where(title: params[:search]).where(text: params[:search])

      #or条件就不能用hash方式写了
      #完全匹配
      #@articles = @articles.where('title = :search or text = :search', search: params[:search])

      #模糊匹配
      #@articles = @articles.where('title like :search or text like :search', search: "%#{params[:search]}%")
    #end

    #性能比较
    #@articles = db_search_only(params[:search])
    #@articles = db_search_mixin_cache(params[:search])
    #@articles = es_search_only(params[:search])
    #@articles = es_search_mixin_cache(params[:search])

    #移动到model层
    #@articles = Article.db_search_only(params[:search], params[:page], params[:per_page])
    #@articles = Article.db_search_mixin_cache(params[:search], params[:page], params[:per_page])
    #@articles = Article.es_search_only(params[:search], params[:page], params[:per_page])
    @articles = Article.es_search_mixin_cache(params[:search], params[:page], params[:per_page])

    #render plain: @articles.to_json and return

    render 'index'
  end

  private
  def article_params
    #params.require(:article).permit!
    #params.require(:my_article).permit(:title, :text)
    params.require(:article).permit(:title, :text, :email, :email_confirmation, :terms_of_service, { tag_ids:[] }, :state,
                                    comments_attributes: [:id, :commenter, :body])
  end

  def load_article
    @article = Article.find(params[:id])
  end

  def load_tags
    @tags = Tag.all
  end

  #def db_search_only(query)
  #  Article.db_search(query).page(params[:page])
  #end
  #
  #def db_search_mixin_cache(query)
  #  articles = Article.db_search(query).page(params[:page])
  #    if articles.size > 0
  #      article_ids = articles.map{|a|"article_#{a.id}"}
  #      #array_articles = Rails.cache.read_multi(*article_ids).values
  #      array_articles = $redis.mget(*article_ids).map{|json_string| Article.new(JSON.parse(json_string))}
  #    else
  #      array_articles = []
  #    end
  #    Kaminari.paginate_array(array_articles, {limit: articles.limit_value, offset: articles.offset_value, total_count: articles.total_count})
  #end
  #
  #def es_search_only(query)
  #  Article.search(params[:search]).page(params[:page]).records
  #end
  #
  #def es_search_mixin_cache(query)
  #  response = Article.search(query).page(params[:page])
  #  if response.results.total > 0
  #    article_ids = response.results.map{|result|"article_#{result._source.id}"}
  #    #array_articles = Rails.cache.read_multi(*article_ids).values
  #    array_articles = $redis.mget(*article_ids).map{|json_string| Article.new(JSON.parse(json_string))}
  #  else
  #    array_articles = []
  #  end
  #  Kaminari.paginate_array(array_articles, {limit: response.limit_value, offset: response.offset_value, total_count: response.total_count})
  #end

  #def take_how_long
  #  begin_time = Time.zone.now.to_f
  #  yield
  #  end_time = Time.zone.now.to_f
  #  time = (end_time - begin_time) * 1000
  #  puts "耗时：#{time}毫秒"
  #end
end
