# frozen_string_literal: true

module Authkeeper
  module VkAdsAuthApi
    module Requests
      module Info
        def info(code:, client_id:, client_secret:, return_raw_response: false)
          form_post(
            path: 'code_info',
            body: {
              code: code,
              client_id: client_id,
              client_secret: client_secret
            },
            headers: {
              'Content-Type' => 'application/x-www-form-urlencoded'
            },
            return_raw_response: return_raw_response
          )
        end
      end
    end
  end
end
