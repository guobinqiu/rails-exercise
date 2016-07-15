# Stay using Rails model layer of ActiveRecord as the validation rather than the Grape built-in validation
module Helpers
  module StrongParamsHelper
    extend Grape::API::Helpers

    def to_controller_params(params)
      ActionController::Parameters.new(params)
    end

    def signup_params(params)
      to_controller_params(params).require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, picture_attributes: [ :id, :name, :imageable_id, :imageable_type ])
    end
  end
end