# frozen_string_literal: true

module Authkeeper
  module VkAuthApi
    module Requests
      module Info
        def info(access_token:, client_id:)
          post(
            path: 'oauth2/user_info',
            body: {
              access_token: access_token,
              client_id: client_id
            }
          )
        end
      end
    end
  end
end
