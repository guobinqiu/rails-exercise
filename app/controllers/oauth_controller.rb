class OauthController < ApplicationController

  def create_login_session
    begin
      auth_hash = request.env["omniauth.auth"]

      @user = User.first_or_initialize(name: auth_hash[:info][:nickname], uid: auth_hash[:uid], provider: auth_hash[:provider])
      if @user.save!
        session[:user_id] = @user.auth_token
        redirect_to session[:return_to] || articles_path
      end
    rescue => e
      #raise e
      render 'users/login'
    end
  end
end
