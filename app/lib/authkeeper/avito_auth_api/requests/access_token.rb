# frozen_string_literal: true

module Authkeeper
  module AvitoAuthApi
    module Requests
      module AccessToken
        def fetch_access_token(client_id:, client_secret:, code:, return_raw_response: false)
          form_post(
            path: 'token',
            body: {
              grant_type: 'authorization_code',
              client_id: client_id,
              client_secret: client_secret,
              code: code
            },
            headers: {
              'Content-Type' => 'application/x-www-form-urlencoded'
            },
            return_raw_response: return_raw_response
          )
        end

        def refresh_access_token(client_id:, client_secret:, refresh_token:, return_raw_response: false)
          form_post(
            path: 'token',
            body: {
              grant_type: 'refresh_token',
              client_id: client_id,
              client_secret: client_secret,
              refresh_token: refresh_token
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
