module Helpers
  module SharedParamsHelper
    extend Grape::API::Helpers

    params :pagination do
      optional :page, type: Integer, default: 1
      optional :per_page, type: Integer, default: 10
    end

  end
end
