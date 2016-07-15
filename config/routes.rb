Rails.application.routes.draw do

  #安装监控异步任务队列
  #https://github.com/mperham/sidekiq/wiki/Monitoring
  #http://127.0.0.1:3000/sidekiq/
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  #mount HelloAPI, at: 'api'
  mount API => '/api'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # rake routes
  # Prefix       Verb   URI Pattern                  Controller#Action
  # articles     GET    /articles(.:format)          articles#index
  #              POST   /articles(.:format)          articles#create
  # new_article  GET    /articles/new(.:format)      articles#new
  # edit_article GET    /articles/:id/edit(.:format) articles#edit
  # article      GET    /articles/:id(.:format)      articles#show
  #              PATCH  /articles/:id(.:format)      articles#update
  #              PUT    /articles/:id(.:format)      articles#update
  #              DELETE /articles/:id(.:format)      articles#destroy
  #resources :articles

  #嵌套路由
  # rake routes
  # Prefix               Verb   URI Pattern                                       Controller#Action
  # article_comments     GET    /articles/:article_id/comments(.:format)          comments#index
  #                      POST   /articles/:article_id/comments(.:format)          comments#create
  # new_article_comment  GET    /articles/:article_id/comments/new(.:format)      comments#new
  # edit_article_comment GET    /articles/:article_id/comments/:id/edit(.:format) comments#edit
  # article_comment      GET    /articles/:article_id/comments/:id(.:format)      comments#show
  #                      PATCH  /articles/:article_id/comments/:id(.:format)      comments#update
  #                      PUT    /articles/:article_id/comments/:id(.:format)      comments#update
  #                      DELETE /articles/:article_id/comments/:id(.:format)      comments#destroy
  # articles             GET    /articles(.:format)          articles#index
  #                      POST   /articles(.:format)          articles#create
  # new_article          GET    /articles/new(.:format)      articles#new
  # edit_article         GET    /articles/:id/edit(.:format) articles#edit
  # article              GET    /articles/:id(.:format)      articles#show
  #                      PATCH  /articles/:id(.:format)      articles#update
  #                      PUT    /articles/:id(.:format)      articles#update
  #                      DELETE /articles/:id(.:format)      articles#destroy
  resources :articles do
    get 'show_more', on: :member
    collection do
      get 'test_json'
      get 'test_js'
      get 'search'
    end
    resources :comments
  end

  #get 'articles/:id/show_more' => 'articles#show_more'
  #get 'articles/:article_id/show_more' => 'articles#show_more'  #分页用到了，感觉有点问题

  resources :tags

  #get 'URI Pattern' => 'Controller#Action', as: 'XXX'
  #get 'users/signup' => 'users#signup', as: 'signup_users'
  #get 'users/login' => 'users#login', as: 'login_users'
  #post 'users/create_login_session' => 'users#create_login_session', as: 'create_login_session_users'
  #delete 'users/logout' => 'users#logout', as: 'logout_users'

  resources :users do
    #这样更好，和上面等效
    collection do
      get 'signup'
      get 'login'
      post 'create_login_session'
      delete 'logout'
    end
    member do
      patch 'upload'
    end
  end

  #get '/auth/qq' => 'oauth_qq#grant'
  #get '/auth/qq/callback' => 'oauth_qq#create_login_session'


  get '/auth/:provider/callback' => 'oauth#create_login_session'
end
