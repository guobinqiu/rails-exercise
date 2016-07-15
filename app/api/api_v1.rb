class API_v1 < Grape::API
  version 'v1', using: :path

  helpers ::Helpers::SharedParamsHelper
  helpers ::Helpers::StrongParamsHelper
  helpers ::Helpers::AuthHelper
  #helpers do
  #  def has_logged_in?
  #    if request.headers['X-Session-Token'].blank?
  #      return nil
  #    end
  #    User.exists?(auth_token: request.headers['X-Session-Token'])
  #  end
  #
  #  def authenticate
  #    error!({error: 'Unsuccessfully logged in'}) unless has_logged_in?
  #  end
  #end

  rescue_from :all do |e|
    error!({error: e.message})
  end

  # auth = 'Basic ' + Base64.encode64('aaa:111').chomp
  http_basic do |username, password|
    username == 'aaa' && password == '111'
  end

  resource :users do
    #curl \
    #  -X POST \
    #  -H 'Content-Type: application/json' \
    #  -H 'Authorization: Basic YWFhOjExMQ==' \
    #  -i 'http://127.0.0.1:3000/api/v1/users/signup' \
    #  -d '{"user": { "name": "Guobin", "email": "qracle@126.com", "password": "111111", "password_confirmation": "111111"} }'
    params do
      requires :user, type: Hash do
        requires :name, type: String
        requires :email, type: String
        requires :password, type: String
        requires :password_confirmation, type: String
      end
    end
    post '/signup' do
      @user = User.create(signup_params(params))
    end

    params do
      requires :name, type: String
      requires :password, type: String
    end
    post '/login' do
      @user = User.find_by(name: params[:name])
      if @user && @user.authenticate(params[:password])
        @user
      else
        error!({error: 'Unsuccessfully logged in'})
      end
    end
  end

  resource :articles do
    #curl \
    #  -X GET \
    #  -H 'Content-Type: application/json' \
    #  -H 'Authorization: Basic YWFhOjExMQ==' \
    #  -H 'X-Session-Token: JHNPlrdy6pO5IRlmKz3nVw' \
    #  -i 'http://127.0.0.1:3000/api/v1/articles/'
    params do
      use :pagination
    end
    get '/' do
      authenticate #假设登录用户才能查看
      @article = Article.all.page(params[:page]).per(params[:per_page])
      {
          articles: @article,
          count: @article.total_count,
          pages: @article.num_pages,
          page: @article.current_page,
          per_page: @article.limit_value,
      }
    end

    params do
      requires :search, type: String
      use :pagination
    end
    get '/search' do
      @article = Article.es_search_mixin_cache(params[:search], params[:page], params[:per_page])
      {
          articles: @article,
          count: @article.total_count,
          pages: @article.num_pages,
          page: @article.current_page,
          per_page: @article.limit_value,
      }
    end

    params do
      requires :id, type: Integer
    end
    get ':id' do
      @article = Article.find(params[:id])
    end

    params do
      requires :id, type: Integer
    end
    get ':id/comments' do
      @comments = Article.find(params[:id]).comments
    end
  end

end