# frozen_string_literal: true

module Authkeeper
  module VkAdsAuthApi
    module Requests
      module Info
        def info(code:, client_id:, client_secret:)
          form_post(
            path: 'code_info',
            body: {
              access_token: access_token,
              client_id: client_id,
              client_secret: client_secret
            },
            headers: {
              'Content-Type' => 'application/x-www-form-urlencoded'
            }
          )
        end
      end
    end
  end
end
