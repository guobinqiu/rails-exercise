module Helpers
  module AuthHelper
    def has_logged_in?
      if request.headers['X-Session-Token'].blank?
        return nil
      end
      User.exists?(auth_token: request.headers['X-Session-Token'])
    end

    def authenticate
      error!({error: 'Unsuccessfully logged in'}) unless has_logged_in?
    end
  end
end