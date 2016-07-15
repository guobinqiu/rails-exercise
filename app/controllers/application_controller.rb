class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #Controller里定义的方法，也可以用helper_method暴露出来当作Helper
  helper_method :current_user


  layout 'application'

  protected
  def current_user
    @current_user ||= session[:user_id] && User.find_by(auth_token: session[:user_id])
  end

end

