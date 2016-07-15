#http://connect.qq.com/
class OauthQqController < ApplicationController
  def grant
    params = {
        response_type: 'code',
        client_id: '101290951',
        redirect_uri: 'http://demo2016.ngrok.cc/auth/qq/callback',
        state: 'demo'
    }
    redirect_to "https://graph.qq.com/oauth2.0/authorize?#{params.to_param}"
  end

  def create_login_session
    begin
      access_token_hash = get_access_token_hash(params[:code])
      openid_hash = get_openid_hash(access_token_hash['access_token'])
      user_info_hash = get_user_info_hash(access_token_hash['access_token'], openid_hash['openid'])
      @user = User.first_or_initialize(name: user_info_hash['nickname'], uid: openid_hash['openid'], provider: 'QQ')
      if @user.save!
        session[:user_id] = @user.auth_token
        redirect_to session[:return_to] || articles_path
      end
    rescue => e
      #raise e
      render 'users/login'
    end
  end

  private
  def get_access_token_hash(code)
    params = {
        grant_type: 'authorization_code',
        client_id: '101290951',
        client_secret: 'fdb9b29d160948c8b7fb01a9a657f47e',
        code: code,
        redirect_uri: 'http://demo2016.ngrok.cc/auth/qq/callback'
    }
    response = RestClient.get "https://graph.qq.com/oauth2.0/token?#{params.to_param}"
    #"access_token=CEF4918E9614F9C1307DCA3FFC32BE55&expires_in=7776000&refresh_token=A6E855EB50CCB6F14BB37D87D413550B"
    access_token = {}
    name_value_pairs = response.split('&')
    name_value_pairs.each do |name_value_pair|
      name = name_value_pair.split('=')[0]
      value = name_value_pair.split('=')[1]
      access_token[name]= value
    end
    access_token
  end

  def get_openid_hash(access_token)
    response = RestClient.get "https://graph.qq.com/oauth2.0/me?access_token=#{access_token}"
    from = response.index('{')
    to = response.index('}')
    JSON.parse(response[from..to])
  end

  def get_user_info_hash(access_token, openid)
    params = {
      access_token: access_token,
      oauth_consumer_key: '101290951',
      openid: openid,
      format: 'json'
    }
    response = RestClient.get "https://graph.qq.com/user/get_user_info?#{params.to_param}"
    JSON.parse(response)
  end
end
