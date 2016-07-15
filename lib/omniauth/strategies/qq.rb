#https://github.com/kaichen/omniauth-qq-connect/blob/master/lib/omniauth/strategies/qq_connect.rb
module OmniAuth
  module Strategies
    class Qq < OmniAuth::Strategies::OAuth2
      option :name, 'qq'

      option :client_options, {
          :site => 'https://graph.qq.com/oauth2.0/',
          :authorize_url => '/oauth2.0/authorize',
          :token_url => "/oauth2.0/token"
      }

      option :token_params, {
          :parse => :query
      }

      uid do
        access_token.options[:mode] = :query
        # Response Example: "callback( {\"client_id\":\"11111\",\"openid\":\"000000FFFF\"} );\n"
        response = access_token.get('/oauth2.0/me')
        matched = response.body.match(/"openid":"(?<openid>\w+)"/)
        matched[:openid]
      end

      info do
        {
            :nickname => get_user_info_hash['nickname'],
            :name => get_user_info_hash['nickname'], # Since it is required, fill it with nickname
            :image => get_user_info_hash['figureurl_qq_1'],
        }
      end

      def get_user_info_hash
        params = {
            access_token: access_token.token,
            oauth_consumer_key: options[:client_id],
            openid: uid,
            format: 'json'
        }
        response = RestClient.get "https://graph.qq.com/user/get_user_info?#{params.to_param}"
        JSON.parse(response)
      end
    end
  end
end